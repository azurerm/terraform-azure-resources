# Hub
[![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurerm/resources/azure/latest/submodules/custom_standalone_site)

Terraform module to create and manage a Standalone Site.

## Example

```hcl
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "standalone_site" {
  source            = "azurerm/resources/azure//modules/custom_standalone_site"
  location          = "westeurope"
  address_space     = ["10.120.0.0/23"]  
}
```

## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_firewall"></a> [firewall](#module\_firewall) | azurerm/resources/azure//modules/firewall | n/a |
| <a name="module_gateway"></a> [gateway](#module\_gateway) | azurerm/resources/azure//modules/virtual_network_gateway | n/a |
| <a name="module_linux_virtual_machine"></a> [linux\_virtual\_machine](#module\_linux\_virtual\_machine) | azurerm/resources/azure//modules/linux_virtual_machine | n/a |
| <a name="module_locations"></a> [locations](#module\_locations) | azurerm/locations/azure | n/a |
| <a name="module_naming"></a> [naming](#module\_naming) | azurerm/naming/azure | n/a |
| <a name="module_public_ip_firewall"></a> [public\_ip\_firewall](#module\_public\_ip\_firewall) | azurerm/resources/azure//modules/public_ip | n/a |
| <a name="module_public_ip_gateway"></a> [public\_ip\_gateway](#module\_public\_ip\_gateway) | azurerm/resources/azure//modules/public_ip | n/a |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | azurerm/resources/azure//modules/resource_group | n/a |
| <a name="module_subnet_firewall"></a> [subnet\_firewall](#module\_subnet\_firewall) | azurerm/resources/azure//modules/subnet | n/a |
| <a name="module_subnet_gateway"></a> [subnet\_gateway](#module\_subnet\_gateway) | azurerm/resources/azure//modules/subnet | n/a |
| <a name="module_subnet_workload"></a> [subnet\_workload](#module\_subnet\_workload) | azurerm/resources/azure//modules/subnet | n/a |
| <a name="module_virtual_network"></a> [virtual\_network](#module\_virtual\_network) | azurerm/resources/azure//modules/virtual_network | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | (Required) The address space that is used the Virtual Network. | `list(string)` | n/a | yes |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | (Optional) The DNS servers to be used with the Virtual Network. | `list(string)` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | (Required) The environment of the Virtual Network. | `string` | `"prd"` | no |
| <a name="input_firewall"></a> [firewall](#input\_firewall) | (Optional) Include a Firewall. | `bool` | `false` | no |
| <a name="input_gateway"></a> [gateway](#input\_gateway) | (Optional) Include a Gateway. | `bool` | `true` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | (Optional) The instance count for the Virtual Network. | `string` | `"001"` | no |
| <a name="input_linux_virtual_machine"></a> [linux\_virtual\_machine](#input\_linux\_virtual\_machine) | (Optional) Include one Linux VM created per subnet. | `bool` | `true` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location/region where the Virtual Network is created. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_module_tags"></a> [module\_tags](#input\_module\_tags) | (Optional) Include the default tags? | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `null` | no |
| <a name="input_virtual_machine_size"></a> [virtual\_machine\_size](#input\_virtual\_machine\_size) | (Optional) The size of the Virtual Machine. | `string` | `"Standard_B1ls"` | no |
| <a name="input_windows_virtual_machine"></a> [windows\_virtual\_machine](#input\_windows\_virtual\_machine) | (Optional) Include one Windows VM created per subnet. | `bool` | `false` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | (Required) The usage or application of the Virtual Network. | `string` | `"standalone"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_linux_virtual_machine_admin_password"></a> [linux\_virtual\_machine\_admin\_password](#output\_linux\_virtual\_machine\_admin\_password) | The password of the Linux Virtual Machine. |
| <a name="output_linux_virtual_machine_admin_username"></a> [linux\_virtual\_machine\_admin\_username](#output\_linux\_virtual\_machine\_admin\_username) | The password of the Linux Virtual Machine. |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of the resource group of the spoke. |
| <a name="output_virtual_network_id"></a> [virtual\_network\_id](#output\_virtual\_network\_id) | The ID of the virtual network of the spoke. |
| <a name="output_virtual_network_name"></a> [virtual\_network\_name](#output\_virtual\_network\_name) | The name of the virtual network of the spoke. |
