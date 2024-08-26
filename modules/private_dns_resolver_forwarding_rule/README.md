<!-- BEGIN_TF_DOCS -->
# Private DNS Resolver Forwarding Rule
[![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurerm/resources/azure/latest/submodules/dns_forwarding_rule)

Terraform module to create and manage a Private DNS Resolver Forwarding Rule.

## Example

```hcl
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "resource_group" {
  source      = "azurerm/resources/azure//modules/resource_group"
  location    = "westeurope"
  environment = "dev"
  workload    = "example"
  instance    = "001"
}

module "private_dns_resolver" {
  source              = "azurerm/resources/azure//modules/private_dns_resolver"
  resource_group_name = module.resource_group.name
  location            = "westeurope"
  environment         = "dev"
  workload            = "example"
  instance            = "001"
}

module "private_dns_resolver_dns_forwarding_ruleset" {
  source              = "azurerm/resources/azure//modules/private_dns_resolver_dns_forwarding_ruleset"
  resource_group_name = module.resource_group.name
  name                = "example"
  private_dns_resolver_outbound_endpoint_ids = [
    module.private_dns_resolver_dns_forwarding_outbound_endpoint.id,
  ]
}

module "private_dns_resolver_forwarding_rule" {
  source                                         = "azurerm/resources/azure//modules/private_dns_resolver_forwarding_rule"
  resource_group_name                            = module.resource_group.name
  private_dns_resolver_dns_forwarding_ruleset_id = module.private_dns_resolver_dns_forwarding_ruleset.id
  domain_name                                    = "example.com"
  forwarding_endpoint_ip_addresses = [{
    ip_address = "10.0.0.4"
    port       = 53
  }]
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_private_dns_resolver_forwarding_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_resolver_forwarding_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_name"></a> [custom\_name](#input\_custom\_name) | The name of the DNS forwarding rule. | `string` | `""` | no |
| <a name="input_dns_forwarding_ruleset_id"></a> [dns\_forwarding\_ruleset\_id](#input\_dns\_forwarding\_ruleset\_id) | The ID of the DNS forwarding ruleset in which to create the DNS forwarding rule. | `string` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The domain name of the DNS forwarding rule. | `string` | n/a | yes |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Is the DNS forwarding rule enabled? | `bool` | `true` | no |
| <a name="input_target_dns_servers"></a> [target\_dns\_servers](#input\_target\_dns\_servers) | The target DNS servers of the DNS forwarding rule. | <pre>list(object({<br>    ip_address = string<br>    port       = number<br>  }))</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->