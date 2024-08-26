<!-- BEGIN_TF_DOCS -->
# Virtual Network Peering
[![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurerm/resources/azure/latest/submodules/virtual_networl_peering)

Terraform module to create and manage a Virtual Network Peering (A => B).

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
  source      = "./modules/resource_group"
  location    = "westeurope"
  environment = "dev"
  workload    = "example"
  instance    = "001"
}

module "virtual_network_1" {
  source              = "azurerm/resources/azure//modules/virtual_network"
  location            = "westeurope"
  environment         = "dev"
  workload            = "example"
  instance            = "001"
  resource_group_name = module.resource_group.name
  address_space       = ["10.0.0.0/24"]
}

module "virtual_network_2" {
  source              = "azurerm/resources/azure//modules/virtual_network"
  location            = "westeurope"
  environment         = "dev"
  workload            = "example"
  instance            = "002"
  resource_group_name = module.resource_group.name
  address_space       = ["10.0.1.0/24"]
}

module "virtual_network_peering" {
  source                    = "azurerm/resources/azure//modules/virtual_network_peering"
  resource_group_name       = module.resource_group.name
  virtual_network_name      = module.virtual_network_1.name
  remote_virtual_network_id = module.virtual_network_2.id
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
| <a name="module_naming"></a> [naming](#module\_naming) | ../naming | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_virtual_network_peering.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_forwarded_traffic"></a> [allow\_forwarded\_traffic](#input\_allow\_forwarded\_traffic) | (Optional) Controls if forwarded traffic from VMs in the remote Virtual Network is allowed. | `bool` | `true` | no |
| <a name="input_allow_gateway_transit"></a> [allow\_gateway\_transit](#input\_allow\_gateway\_transit) | (Optional) Controls gatewayLinks can be used in the remote Virtual Network’s link to the local Virtual Network. | `bool` | `false` | no |
| <a name="input_allow_virtual_network_access"></a> [allow\_virtual\_network\_access](#input\_allow\_virtual\_network\_access) | (Optional) Controls if the VMs in the remote Virtual Network can access VMs in the local Virtual Network. | `bool` | `true` | no |
| <a name="input_custom_name"></a> [custom\_name](#input\_custom\_name) | (Optional) The name of the Virtual Network. | `string` | `""` | no |
| <a name="input_remote_virtual_network_id"></a> [remote\_virtual\_network\_id](#input\_remote\_virtual\_network\_id) | (Required) The ID of the remote Virtual Network to peer with. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the Virtual Network. | `string` | n/a | yes |
| <a name="input_use_remote_gateways"></a> [use\_remote\_gateways](#input\_use\_remote\_gateways) | (Optional) Controls if remote gateways can be used on the local Virtual Network. | `bool` | `false` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | (Required) The name of the Virtual Network. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Virutal Network Peering. |
| <a name="output_name"></a> [name](#output\_name) | The name of the Virutal Network Peering. |
<!-- END_TF_DOCS -->