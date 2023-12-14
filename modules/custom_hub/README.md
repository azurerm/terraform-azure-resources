# Hub
[![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurerm/resources/azure/latest/submodules/custom_hub)

Terraform module to create and manage an Hub.

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

module "hub" {
  source        = "azurerm/resources/azure//modules/custom_hub"
  location      = "westeurope"
  environment   = "prd"
  workload      = "hub"
  address_space = ["10.0.1.0/24"]
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
| <a name="module_bastion"></a> [bastion](#module\_bastion) | ../bastion_host | n/a |
| <a name="module_bastion_diagnostic_setting"></a> [bastion\_diagnostic\_setting](#module\_bastion\_diagnostic\_setting) | ../monitor_diagnostic_setting | n/a |
| <a name="module_firewall"></a> [firewall](#module\_firewall) | ../firewall | n/a |
| <a name="module_firewall_diagnostic_setting"></a> [firewall\_diagnostic\_setting](#module\_firewall\_diagnostic\_setting) | ../monitor_diagnostic_setting | n/a |
| <a name="module_firewall_policy"></a> [firewall\_policy](#module\_firewall\_policy) | ../firewall_policy | n/a |
| <a name="module_firewall_workbook"></a> [firewall\_workbook](#module\_firewall\_workbook) | ../firewall_workbook | n/a |
| <a name="module_gateway"></a> [gateway](#module\_gateway) | ../virtual_network_gateway | n/a |
| <a name="module_gateway_diagnostic_setting"></a> [gateway\_diagnostic\_setting](#module\_gateway\_diagnostic\_setting) | ../monitor_diagnostic_setting | n/a |
| <a name="module_key_vault"></a> [key\_vault](#module\_key\_vault) | ../key_vault | n/a |
| <a name="module_log_analytics_workspace"></a> [log\_analytics\_workspace](#module\_log\_analytics\_workspace) | ../log_analytics_workspace | n/a |
| <a name="module_public_ip_bastion"></a> [public\_ip\_bastion](#module\_public\_ip\_bastion) | ../public_ip | n/a |
| <a name="module_public_ip_firewall"></a> [public\_ip\_firewall](#module\_public\_ip\_firewall) | ../public_ip | n/a |
| <a name="module_public_ip_gateway"></a> [public\_ip\_gateway](#module\_public\_ip\_gateway) | ../public_ip | n/a |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | ../resource_group | n/a |
| <a name="module_route_table_gateway"></a> [route\_table\_gateway](#module\_route\_table\_gateway) | ../route_table | n/a |
| <a name="module_subnet_bastion"></a> [subnet\_bastion](#module\_subnet\_bastion) | ../subnet | n/a |
| <a name="module_subnet_firewall"></a> [subnet\_firewall](#module\_subnet\_firewall) | ../subnet | n/a |
| <a name="module_subnet_gateway"></a> [subnet\_gateway](#module\_subnet\_gateway) | ../subnet | n/a |
| <a name="module_subnet_route_table_association_gateway"></a> [subnet\_route\_table\_association\_gateway](#module\_subnet\_route\_table\_association\_gateway) | ../subnet_route_table_association | n/a |
| <a name="module_virtual_network"></a> [virtual\_network](#module\_virtual\_network) | ../virtual_network | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | (Required) The address space that is used the Virtual Network. | `list(string)` | n/a | yes |
| <a name="input_bastion"></a> [bastion](#input\_bastion) | (Optional) Include a Bastion Host. | `bool` | `true` | no |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | (Optional) The DNS servers to be used with the Virtual Network. | `list(string)` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | (Required) The environment of the Virtual Network. | `string` | `"prd"` | no |
| <a name="input_firewall"></a> [firewall](#input\_firewall) | (Optional) Include a Firewall. | `bool` | `true` | no |
| <a name="input_gateway"></a> [gateway](#input\_gateway) | (Optional) Include a Gateway. | `bool` | `true` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | (Optional) The instance count for the Virtual Network. | `string` | `"001"` | no |
| <a name="input_key_vault"></a> [key\_vault](#input\_key\_vault) | (Optional) Include a Key Vault. | `bool` | `true` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location/region where the Virtual Network is created. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_module_tags"></a> [module\_tags](#input\_module\_tags) | (Optional) Include the default tags? | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `null` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | (Required) The usage or application of the Virtual Network. | `string` | `"hub"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_firewall_policy_id"></a> [firewall\_policy\_id](#output\_firewall\_policy\_id) | The ID of the Firewall Policy. |
| <a name="output_firewall_private_ip_address"></a> [firewall\_private\_ip\_address](#output\_firewall\_private\_ip\_address) | The private IP address of the Firewall. |
| <a name="output_firewall_public_ip_address"></a> [firewall\_public\_ip\_address](#output\_firewall\_public\_ip\_address) | The public IP address of the Firewall. |
| <a name="output_key_vault_id"></a> [key\_vault\_id](#output\_key\_vault\_id) | The ID of the Key Vault. |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of the resource group of the spoke. |
| <a name="output_route_table_name"></a> [route\_table\_name](#output\_route\_table\_name) | The name of the Route Table. |
| <a name="output_virtual_network_id"></a> [virtual\_network\_id](#output\_virtual\_network\_id) | The ID of the virtual network of the spoke. |
| <a name="output_virtual_network_name"></a> [virtual\_network\_name](#output\_virtual\_network\_name) | The name of the virtual network of the spoke. |
