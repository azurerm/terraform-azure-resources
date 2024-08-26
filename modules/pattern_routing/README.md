<!-- BEGIN_TF_DOCS -->
# Route Table
[![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurerm/resources/azure/latest/submodules/pattern_routing)

Terraform module to create and manage a routing.

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


module "route_table" {
  source              = "azurerm/resources/azure//modules/route_table"
  resource_group_name = module.resource_group.name
  location            = "westeurope"
  environment         = "dev"
  workload            = "example"
  instance            = "001"
}

module "resource_group" {
  source      = "azurerm/resources/azure//modules/resource_group"
  location    = "westeurope"
  environment = "dev"
  workload    = "example"
  instance    = "001"
}

module "virtual_network" {
  source              = "azurerm/resources/azure//modules/virtual_network"
  location            = "westeurope"
  environment         = "dev"
  workload            = "example"
  instance            = "001"
  resource_group_name = module.resource_group.name
  address_space       = ["10.0.0.0/24"]
}

module "subnet" {
  source               = "azurerm/resources/azure//modules/subnet"
  location             = "westeurope"
  environment          = "dev"
  workload             = "example"
  instance             = "001"
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.virtual_network.name
  address_prefixes     = ["10.0.0.0/25"]
}

module "routing" {
  source              = "azurerm/resources/azure//modules/pattern_routing"
  location            = "westeurope"
  environment         = "dev"
  workload            = "example"
  instance            = "001"
  resource_group_name = module.resource_group.name
  default_next_hop    = "10.0.1.4"
  subnet_id           = module.subnet.id
}
```

## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_route"></a> [route](#module\_route) | ../route | n/a |
| <a name="module_route_net10"></a> [route\_net10](#module\_route\_net10) | ../route | n/a |
| <a name="module_route_net172"></a> [route\_net172](#module\_route\_net172) | ../route | n/a |
| <a name="module_route_net192"></a> [route\_net192](#module\_route\_net192) | ../route | n/a |
| <a name="module_route_table"></a> [route\_table](#module\_route\_table) | ../route_table | n/a |
| <a name="module_subnet_route_table_association"></a> [subnet\_route\_table\_association](#module\_subnet\_route\_table\_association) | ../subnet_route_table_association | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_name"></a> [custom\_name](#input\_custom\_name) | (Optional) The name of the Route Table. | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | (Optional) The environment of the Route Table. | `string` | `""` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | (Optional) The instance count for the Route Table. | `string` | `""` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location/region where the Route Table is created. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_module_tags"></a> [module\_tags](#input\_module\_tags) | (Optional) Include the default tags? | `bool` | `true` | no |
| <a name="input_next_hop"></a> [next\_hop](#input\_next\_hop) | (Optional) The IP address packets should be forwarded to when they don't match any of the routes in the route table. | `string` | `""` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the Route Table. | `string` | n/a | yes |
| <a name="input_routing_type"></a> [routing\_type](#input\_routing\_type) | (Optional) The routing behavior of the Route Table. Valid values are default and private. | `string` | `"default"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | (Required) The ID of the Subnet which should be associated with this Route Table. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `null` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | (Optional) The usage or application of the Route Table. | `string` | `""` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->