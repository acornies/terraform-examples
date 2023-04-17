output "vault_namespaces" {
    # Use a for expression to output the namespace path_fq for each namespace
    # value = { for k, ns in vault_namespace.tenants : k => ns.path_fq }
    # Another example output
    value = values(vault_namespace.tenants).*.path_fq
}