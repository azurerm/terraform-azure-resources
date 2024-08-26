<!-- BEGIN_TF_DOCS -->
# Route Table
[![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurerm/resources/azure/latest/submodules/route)

Terraform module to create and manage a Route.

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

module "route" {
  source              = "azurerm/resources/azure//modules/route"
  resource_group_name = module.resource_group.name
  route_table_id      = module.route_table.id
  name                = "example"
  address_prefix      = "10.0.0.0/24"
  next_hop_type       = "VirtualAppliance"
  next_hop_in_ip      = "10.0.1.4"
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
| [azurerm_route.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_prefix"></a> [address\_prefix](#input\_address\_prefix) | (Required) The destination CIDR to which the route applies. | `string` | n/a | yes |
| <a name="input_custom_name"></a> [custom\_name](#input\_custom\_name) | (Optional) The name of the Virtual Network. | `string` | `""` | no |
| <a name="input_next_hop_in_ip_address"></a> [next\_hop\_in\_ip\_address](#input\_next\_hop\_in\_ip\_address) | (Optional) The IP address packets should be forwarded to. Next hop values are only allowed in routes where the next hop type is VirtualAppliance. | `string` | `""` | no |
| <a name="input_next_hop_type"></a> [next\_hop\_type](#input\_next\_hop\_type) | (Required) The type of Azure hop the packet should be sent to. Possible values are VirtualNetworkGateway, VnetLocal, Internet, VirtualAppliance and None. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the Virtual Network. | `string` | n/a | yes |
| <a name="input_route_table_name"></a> [route\_table\_name](#input\_route\_table\_name) | (Required) The name of the Route Table. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->