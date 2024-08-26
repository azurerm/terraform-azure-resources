<!-- BEGIN_TF_DOCS -->
# Private DNS Resolver
[![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurerm/resources/azure/latest/submodules/private_dns_resolver)

Terraform module to create and manage a Private DNS Resolver.

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
| [azurerm_private_dns_resolver.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_resolver) | resource |
| [azurerm_private_dns_resolver_inbound_endpoint.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_resolver_inbound_endpoint) | resource |
| [azurerm_private_dns_resolver_outbound_endpoint.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_resolver_outbound_endpoint) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_name"></a> [custom\_name](#input\_custom\_name) | (Optional) The name of the Private DNS Resolver | `string` | `""` | no |
| <a name="input_custom_name_inbound_endpoint"></a> [custom\_name\_inbound\_endpoint](#input\_custom\_name\_inbound\_endpoint) | (Optional) The name of the Private DNS Resolver Inbound Endpoint. | `string` | `""` | no |
| <a name="input_custom_name_outbound_endpoint"></a> [custom\_name\_outbound\_endpoint](#input\_custom\_name\_outbound\_endpoint) | (Optional) The name of the Private DNS Resolver Outbound Endpoint. | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | (Optional) The environment of the Private DNS Resolver. | `string` | `"prd"` | no |
| <a name="input_inbound_endpoint_subnet_id"></a> [inbound\_endpoint\_subnet\_id](#input\_inbound\_endpoint\_subnet\_id) | (Required) The ID of the subnet to use for the Private DNS Resolver Inbound Endpoint. | `string` | n/a | yes |
| <a name="input_instance"></a> [instance](#input\_instance) | (Optional) The instance count for the Private DNS Resolver. | `string` | `"001"` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location/region where the Private DNS Resolver is created. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_module_tags"></a> [module\_tags](#input\_module\_tags) | (Optional) Include the default tags? | `bool` | `true` | no |
| <a name="input_outbound_endpoint_subnet_id"></a> [outbound\_endpoint\_subnet\_id](#input\_outbound\_endpoint\_subnet\_id) | (Required) The ID of the subnet to use for the Private DNS Resolver Outbound Endpoint. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the Virtual Network. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `null` | no |
| <a name="input_virtual_network_id"></a> [virtual\_network\_id](#input\_virtual\_network\_id) | (Required) The ID of the Virtual Network in which to create the Private DNS Resolver. | `string` | n/a | yes |
| <a name="input_workload"></a> [workload](#input\_workload) | (Optional) The usage or application of the Private DNS Resolver. | `string` | `"dns"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Private DNS Resolver. |
| <a name="output_inbound_endpoint_ip"></a> [inbound\_endpoint\_ip](#output\_inbound\_endpoint\_ip) | The IP address of the Private DNS Resolver Inbound Endpoint. |
| <a name="output_name"></a> [name](#output\_name) | The name of the Private DNS Resolver. |
| <a name="output_outbound_endpoint_id"></a> [outbound\_endpoint\_id](#output\_outbound\_endpoint\_id) | The ID of the Private DNS Resolver Outbound Endpoint. |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of the resource group in which to create Private DNS Resolver. |
<!-- END_TF_DOCS -->