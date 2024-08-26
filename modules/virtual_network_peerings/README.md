<!-- BEGIN_TF_DOCS -->
# Virtual Network Peerings
[![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurerm/resources/azure/latest/submodules/virtual_networl_peering)

Terraform module to create and manage a Virtual Network Peerings (A <=> B).

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

module "virtual_network_peerings" {
  source                                = "azurerm/resources/azure//modules/virtual_network_peerings"
  virtual_network_1_resource_group_name = module.resource_group.name
  virtual_network_1_id                  = module.virtual_network_1.id
  virtual_network_2_resource_group_name = module.resource_group.name
  virtual_network_2_id                  = module.virtual_network_2.id
}
```

## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_peering_1_to_2"></a> [peering\_1\_to\_2](#module\_peering\_1\_to\_2) | ../virtual_network_peering | n/a |
| <a name="module_peering_2_to_1"></a> [peering\_2\_to\_1](#module\_peering\_2\_to\_1) | ../virtual_network_peering | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_forwarded_traffic"></a> [allow\_forwarded\_traffic](#input\_allow\_forwarded\_traffic) | (Optional) Controls if forwarded traffic from VMs in the remote Virtual Network is allowed. | `bool` | `true` | no |
| <a name="input_allow_virtual_network_access"></a> [allow\_virtual\_network\_access](#input\_allow\_virtual\_network\_access) | (Optional) Controls if the VMs in the remote Virtual Network can access VMs in the local Virtual Network. | `bool` | `true` | no |
| <a name="input_virtual_network_1_hub"></a> [virtual\_network\_1\_hub](#input\_virtual\_network\_1\_hub) | (Optional) Is Virtual Network 1 hub? | `bool` | `false` | no |
| <a name="input_virtual_network_1_id"></a> [virtual\_network\_1\_id](#input\_virtual\_network\_1\_id) | (Required) The name of the Virtual Network. | `string` | n/a | yes |
| <a name="input_virtual_network_1_resource_group_name"></a> [virtual\_network\_1\_resource\_group\_name](#input\_virtual\_network\_1\_resource\_group\_name) | (Required) The name of the resource group in which to create the Virtual Network. | `string` | n/a | yes |
| <a name="input_virtual_network_2_id"></a> [virtual\_network\_2\_id](#input\_virtual\_network\_2\_id) | (Required) The name of the Virtual Network. | `string` | n/a | yes |
| <a name="input_virtual_network_2_resource_group_name"></a> [virtual\_network\_2\_resource\_group\_name](#input\_virtual\_network\_2\_resource\_group\_name) | (Required) The name of the resource group in which to create the Virtual Network. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->