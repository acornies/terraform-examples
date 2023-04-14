provider "vault" {
  namespace = "admin"
}

resource "vault_namespace" "tenants" {
  for_each = var.tenants
  path     = each.key
}

resource "vault_mount" "kv_secrets" {
  for_each  = var.tenants
  namespace = vault_namespace.tenants[each.key].path_fq
  path      = "secrets"
  type      = "kv"
  options = {
    version = "1"
  }
}

resource "vault_auth_backend" "approle_backend" {
  for_each  = var.tenants
  namespace = vault_namespace.tenants[each.key].path_fq
  type      = "approle"
  path      = "approle"
}

resource "vault_approle_auth_backend_role" "approle_role_dev" {
  for_each       = var.tenants
  namespace      = vault_namespace.tenants[each.key].path_fq
  backend        = vault_auth_backend.approle_backend[each.key].path
  role_name      = "dev"
  token_policies = ["default", "dev"]
}

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

resource "vault_github_auth_backend" "auth_github" {
  for_each  = var.tenants
  namespace = vault_namespace.tenants[each.key].path_fq
  organization = "my-org"
}

resource "vault_github_team" "tf_devs" {
  for_each  = var.tenants
  namespace = vault_namespace.tenants[each.key].path_fq
  backend  = vault_github_auth_backend.auth_github[each.key].id
  team     = each.value.team
  policies = ["dev"]
}