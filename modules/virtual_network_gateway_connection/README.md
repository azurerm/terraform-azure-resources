<!-- BEGIN_TF_DOCS -->
# Local Network Gateway
[![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurerm/resources/azure/latest/submodules/local_network_gateway)

Terraform module to create and manage a local network gateway.

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

module "local_network_gateway" {
  source              = "azurerm/resources/azure//modules/local_network_gateway"
  resource_group_name = module.resource_group.name
  location            = "westeurope"
  environment         = "dev"
  workload            = "example"
  instance            = "001"
  gateway_address     = "1.2.3.4"
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
| [azurerm_virtual_network_gateway_connection.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway_connection) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_connection_mode"></a> [connection\_mode](#input\_connection\_mode) | (Optional) The connection mode. | `string` | `"Default"` | no |
| <a name="input_connection_protocol"></a> [connection\_protocol](#input\_connection\_protocol) | (Optional) The connection protocol. | `string` | `"IKEv2"` | no |
| <a name="input_custom_name"></a> [custom\_name](#input\_custom\_name) | (Optional) The name of the Virtual Network. | `string` | `""` | no |
| <a name="input_enable_bgp"></a> [enable\_bgp](#input\_enable\_bgp) | (Optional) Is BGP Enabled? | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | (Optional) The environment of the Virtual Network. | `string` | `""` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | (Optional) The instance count for the Virtual Network. | `string` | `""` | no |
| <a name="input_local_network_gateway_id"></a> [local\_network\_gateway\_id](#input\_local\_network\_gateway\_id) | (Required) The ID of the local network gateway. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location/region where the Virtual Network is created. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_module_tags"></a> [module\_tags](#input\_module\_tags) | (Optional) Include the default tags? | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the Virtual Network. | `string` | n/a | yes |
| <a name="input_routing_weight"></a> [routing\_weight](#input\_routing\_weight) | (Optional) The routing weight. | `number` | `10` | no |
| <a name="input_shared_key"></a> [shared\_key](#input\_shared\_key) | (Required) The shared key. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `null` | no |
| <a name="input_type"></a> [type](#input\_type) | (Optional) The type of connection. | `string` | `"IPsec"` | no |
| <a name="input_virtual_network_gateway_id"></a> [virtual\_network\_gateway\_id](#input\_virtual\_network\_gateway\_id) | (Required) The ID of the virtual network gateway. | `string` | n/a | yes |
| <a name="input_workload"></a> [workload](#input\_workload) | (Optional) The usage or application of the Virtual Network. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_shared_key"></a> [shared\_key](#output\_shared\_key) | The shared key. |
<!-- END_TF_DOCS -->