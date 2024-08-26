<!-- BEGIN_TF_DOCS -->
# Private DNS Resolver Forwarding Ruleset
[![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurerm/resources/azure/latest/submodules/dns_forwarding_ruleset)

Terraform module to create and manage a Private DNS Resolver Forwarding Ruleset.

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
  
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_locations"></a> [locations](#module\_locations) | ../locations | n/a |
| <a name="module_naming"></a> [naming](#module\_naming) | ../naming | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_private_dns_resolver_dns_forwarding_ruleset.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_resolver_dns_forwarding_ruleset) | resource |
| [azurerm_private_dns_resolver_virtual_network_link.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_resolver_virtual_network_link) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_name"></a> [custom\_name](#input\_custom\_name) | (Optional) The name of the Private DNS Resolver Forwarding Rule Set. | `string` | `""` | no |
| <a name="input_custom_name_link"></a> [custom\_name\_link](#input\_custom\_name\_link) | (Optional) The name of the Private DNS Resolver Forwarding Rule Set Link. | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | (Optional) The environment of the Private DNS Resolver. | `string` | `"prd"` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | (Optional) The instance count for the Private DNS Resolver. | `string` | `"001"` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location/region where the Private DNS Resolver is created. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_module_tags"></a> [module\_tags](#input\_module\_tags) | (Optional) Include the default tags? | `bool` | `true` | no |
| <a name="input_private_dns_resolver_outbound_endpoint_ids"></a> [private\_dns\_resolver\_outbound\_endpoint\_ids](#input\_private\_dns\_resolver\_outbound\_endpoint\_ids) | (Required) The ID of the subnet to use for the Private DNS Resolver Inbound Endpoint. | `list(string)` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the Virtual Network. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `null` | no |
| <a name="input_virtual_network_id"></a> [virtual\_network\_id](#input\_virtual\_network\_id) | (Required) The ID of the Virtual Network in which to create the Private DNS Resolver. | `string` | n/a | yes |
| <a name="input_workload"></a> [workload](#input\_workload) | (Optional) The usage or application of the Private DNS Resolver. | `string` | `"dns"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the DNS forwarding rule. |
<!-- END_TF_DOCS -->