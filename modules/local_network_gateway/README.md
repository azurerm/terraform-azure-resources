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
| [azurerm_local_network_gateway.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/local_network_gateway) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | (Optional) The address space of the local network gateway. | `list(string)` | `[]` | no |
| <a name="input_asn"></a> [asn](#input\_asn) | (Optional) The ASN of the local network gateway. | `string` | `""` | no |
| <a name="input_bgp_peering_address"></a> [bgp\_peering\_address](#input\_bgp\_peering\_address) | (Optional) The BGP peering address of the local network gateway. | `string` | `""` | no |
| <a name="input_custom_name"></a> [custom\_name](#input\_custom\_name) | (Optional) The name of the Local Network Gateway. | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | (Optional) The environment of the Local Network Gateway. | `string` | `""` | no |
| <a name="input_gateway_address"></a> [gateway\_address](#input\_gateway\_address) | (Optional) The IP address of the local network gateway. | `string` | `null` | no |
| <a name="input_gateway_fqdn"></a> [gateway\_fqdn](#input\_gateway\_fqdn) | (Optional) The FQDN of the local network gateway. | `string` | `null` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | (Optional) The instance count for the Local Network Gateway. | `string` | `""` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location/region where the Local Network Gateway is created. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_module_tags"></a> [module\_tags](#input\_module\_tags) | (Optional) Include the default tags? | `bool` | `true` | no |
| <a name="input_peer_weight"></a> [peer\_weight](#input\_peer\_weight) | (Optional) The peer weight of the local network gateway. | `number` | `0` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the Local Network Gateway. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `null` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | (Optional) The usage or application of the Local Network Gateway. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Local Network Gateway. |
<!-- END_TF_DOCS -->