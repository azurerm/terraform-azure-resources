<!-- BEGIN_TF_DOCS -->
# Private DNS Resolver Forwarding Ruleset
[![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurerm/resources/azure/latest/submodules/private_dns_zone)

Terraform module to create and manage a Private DNS Zone.

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

module "private_dns_zone" {
  source              = "azurerm/resources/azure//modules/private_dns_zone"
  resource_group_name = module.resource_group.name
  name                = "example.com"
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
| [azurerm_private_dns_zone.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | (Optional) The environment of the Private DNS Resolver. | `string` | `"prd"` | no |
| <a name="input_module_tags"></a> [module\_tags](#input\_module\_tags) | (Optional) Include the default tags? | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the Private DNS Zone. | `string` | `""` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the Virtual Network. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `null` | no |
| <a name="input_virtual_network_id"></a> [virtual\_network\_id](#input\_virtual\_network\_id) | (Optional) The ID of the Virtual Network in which to create the Private DNS Resolver. | `string` | `null` | no |
| <a name="input_virtual_network_link"></a> [virtual\_network\_link](#input\_virtual\_network\_link) | (Optional) The ID of the Virtual Network Link to associate with the Private DNS Resolver. | `string` | `false` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | (Optional) The usage or application of the Private DNS Resolver. | `string` | `"dns"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Private DNS Zone. |
| <a name="output_name"></a> [name](#output\_name) | The name of the Private DNS Zone. |
<!-- END_TF_DOCS -->