# terraform-examples

A repository for example Terraform configurations that expand on examples from the Terraform registry docs and developer.hashicorp.com.

```bash
.
└── vault_namespaces_map
```
## Vault namespaces map

This example uses a map (object) variable type to manage Vault namespaces and use object properties to assign different team access. The example uses Terraform to provision a collection of:
- namespaces
- secret engines per namespace
- approle auth method per namespace
- github auth method per namespace
- different github team access based on the tenant map property "team"

This example can be extended to any resource in the [HashiCorp Vault provider](https://registry.terraform.io/providers/hashicorp/vault/latest/docs).

### Use case

Onboarding teams to use Vault enterprise most likely requires the creation of namespaces. Through Terraform and GitOps, we can use a familiar workflow to first approve a PR for a new workspace through IaC, then have Terraform Cloud trigger the Terraform run in an automated fashion upon PR merge. This vastly improves upon a ticketing process that relies on waiting for a Vault administrator to create a namespace for a team/project to give them access.

### How to use

Developers or operators open a PR and update ./terraform.tfvars with their desired namespace and team name. In this example, the team name matches a desired team on GitHub to control the auth access to the namespace.

### Outcomes

Engineering teams benefit from increased velocity in getting secure access to a namespace, often saving hundreds of FTE hours or waiting time per month.