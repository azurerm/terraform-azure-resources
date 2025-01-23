<!-- BEGIN_TF_DOCS -->
# Firewall
[![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurerm/resources/azure/latest/submodules/firewall)

Terraform module to create and manage a Firewall.

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
  environment = "prd"
  workload    = "hub"
  instance    = "001"
}

module "virtual_network" {
  source              = "azurerm/resources/azure//modules/virtual_network"
  location            = "westeurope"
  environment         = "prd"
  workload            = "hub"
  instance            = "001"
  resource_group_name = module.resource_group.name
  address_space       = ["10.0.0.0/24"]
}

module "subnet" {
  source               = "azurerm/resources/azure//modules/subnet"
  location             = "westeurope"
  custom_name          = "AzureFirewallSubnet"
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.virtual_network.name
  address_prefixes     = ["10.0.0.0/25"]
}

module "publicip" {
  source              = "azurerm/resources/azure//modules/public_ip"
  location            = "westeurope"
  environment         = "prd"
  workload            = "firewall"
  instance            = "001"
  resource_group_name = module.resource_group.name
}

module "firewall" {
  source               = "azurerm/resources/azure//modules/firewall"
  location             = "westeurope"
  environment          = "prd"
  workload             = "firewall"
  instance             = "001"
  resource_group_name  = module.resource_group.name
  public_ip_address_id = module.publicip.id
  subnet_id            = module.subnet.id
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
| [azurerm_firewall.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_name"></a> [custom\_name](#input\_custom\_name) | (Optional) The name of the Virtual Network. | `string` | `""` | no |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | (Optional) A list of DNS servers that the Azure Firewall will direct DNS traffic to the for name resolution. | `list(string)` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | (Optional) The environment of the Virtual Network. | `string` | `""` | no |
| <a name="input_firewall_policy_id"></a> [firewall\_policy\_id](#input\_firewall\_policy\_id) | (Optional) The ID of the Firewall Policy. | `string` | `null` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | (Optional) The instance count for the Virtual Network. | `string` | `""` | no |
| <a name="input_ip_configuration_name"></a> [ip\_configuration\_name](#input\_ip\_configuration\_name) | (Optional) The name of the IP Configuration. | `string` | `"ipconfig"` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location/region where the Virtual Network is created. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | (Optional) The ID of the Log Analytics Workspace. | `string` | `""` | no |
| <a name="input_module_tags"></a> [module\_tags](#input\_module\_tags) | (Optional) Include the default tags? | `bool` | `true` | no |
| <a name="input_private_ip_ranges"></a> [private\_ip\_ranges](#input\_private\_ip\_ranges) | (Optional) A list of private IP address ranges that will be used by subnets. | `list(string)` | `null` | no |
| <a name="input_public_ip_address_id"></a> [public\_ip\_address\_id](#input\_public\_ip\_address\_id) | (Required) The ID of the Public IP Address. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the Virtual Network. | `string` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | (Optional) SKU name of the Firewall. | `string` | `"AZFW_VNet"` | no |
| <a name="input_sku_tier"></a> [sku\_tier](#input\_sku\_tier) | (Optional) SKU tier of the Firewall. | `string` | `"Standard"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | (Required) The ID of the Subnet. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `null` | no |
| <a name="input_threat_intel_mode"></a> [threat\_intel\_mode](#input\_threat\_intel\_mode) | (Optional) The operation mode for Threat Intelligence. | `string` | `"Alert"` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | (Optional) The usage or application of the Virtual Network. | `string` | `""` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | (Optional) A list of availability zones which to deploy the firewall in. | `list(string)` | <pre>[<br>  "1",<br>  "2",<br>  "3"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Firewall. |
| <a name="output_name"></a> [name](#output\_name) | The name of the Firewall. |
| <a name="output_private_ip_address"></a> [private\_ip\_address](#output\_private\_ip\_address) | The private IP address of the Firewall. |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of the resource group in which to create the Firewall. |
<!-- END_TF_DOCS -->