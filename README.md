# terraform-examples

A repository for example Terraform configurations that expand on examples from the Terraform registry docs and developer.hashicorp.com.

```bash
.
└── vault_namespaces_map
```
### Vault namespaces map

This example uses a map (object) variable type to manage Vault namespaces and use object properties to assign different team access. The example uses Terraform to provision a collection of:
- namespaces
- secret engines per namespace
- approle auth method per namespace
- github auth method per namespace
- different github team access based on the tenant map property "team"

This example can be extended to any resource in the [HashiCorp Vault provider](https://registry.terraform.io/providers/hashicorp/vault/latest/docs)
