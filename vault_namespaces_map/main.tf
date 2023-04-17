# approle auth is a good option for TFC workspace usage
provider "vault" {
  namespace = "admin"
  # auth_login {
  #   path = "auth/approle/login"
  #   parameters = {
  #     ...
  #   }
  # }
}

# Create the namespaces from the map defined in variables.tf
resource "vault_namespace" "tenants" {
  for_each = var.tenants
  path     = each.key
}

# Create the secrets v1 engine in each namespace under path "secrets"
resource "vault_mount" "kv_secrets" {
  for_each  = var.tenants
  namespace = vault_namespace.tenants[each.key].path_fq
  path      = "secrets"
  type      = "kv"
  options = {
    version = "1"
  }
}

# Create an approle auth backend in each namespace under path "approle"
resource "vault_auth_backend" "approle_backend" {
  for_each  = var.tenants
  namespace = vault_namespace.tenants[each.key].path_fq
  type      = "approle"
  path      = "approle"
}

# Create a "dev" approle auth role in each namespace under path approle auth method
resource "vault_approle_auth_backend_role" "approle_role_dev" {
  for_each       = var.tenants
  namespace      = vault_namespace.tenants[each.key].path_fq
  backend        = vault_auth_backend.approle_backend[each.key].path
  role_name      = "dev"
  token_policies = ["default", "dev"]
}

# Create a "dev" policy in each namespace
resource "vault_policy" "dev" {
  for_each  = var.tenants
  namespace = vault_namespace.tenants[each.key].path_fq
  name      = "dev"
  policy    = <<EOT
path "secret/*" {
  capabilities = ["update"]
}
EOT
}

# Create a GitHub auth backend in each namespace under path "github"
resource "vault_github_auth_backend" "auth_github" {
  for_each  = var.tenants
  namespace = vault_namespace.tenants[each.key].path_fq
  organization = "my-org"
}

# Use the "team" property in the tenants variable to assign the appropriate GitHub
# team for the GitHub auth backend for each namespace, assign it the "dev" policy
resource "vault_github_team" "tf_devs" {
  for_each  = var.tenants
  namespace = vault_namespace.tenants[each.key].path_fq
  backend  = vault_github_auth_backend.auth_github[each.key].id
  team     = each.value.team
  policies = ["dev"]
}