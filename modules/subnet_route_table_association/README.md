<!-- BEGIN_TF_DOCS -->
# Association subnet / route table
[![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurerm/resources/azure/latest/submodules/subnet_route_table_association)

Terraform module to create and manage an Association between a subnet and a route table.

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

module "route_table" {
  source              = "azurerm/resources/azure//modules/route_table"
  resource_group_name = module.resource_group.name
  location            = "westeurope"
  environment         = "dev"
  workload            = "example"
  instance            = "001"
}

module "virtual_network" {
  source              = "azurerm/resources/azure//modules/virtual_network"
  resource_group_name = module.resource_group.name
  location            = "westeurope"
  environment         = "dev"
  workload            = "example"
  instance            = "001"
  address_space       = ["10.0.0.0/24"]
}

module "subnet" {
  source              = "azurerm/resources/azure//modules/subnet"
  resource_group_name = module.resource_group.name
  virtual_network_id  = module.virtual_network.id
  name                = "example"
  address_prefixes    = ["10.0.0.0/25"]
}

module "subnet_route_table_association" {
  source              = "azurerm/resources/azure//modules/subnet_route_table_association"
  resource_group_name = module.resource_group.name
  subnet_id           = module.subnet.id
  route_table_id      = module.route_table.id
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
| [azurerm_subnet_route_table_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_route_table_id"></a> [route\_table\_id](#input\_route\_table\_id) | (Required) The ID of the Route Table. | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | (Required) The ID of the Subnet. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Subnet Route Table Association. |
<!-- END_TF_DOCS -->