<!-- BEGIN_TF_DOCS -->
# Hub
[![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurerm/resources/azure/latest/submodules/pattern_hub)

Terraform module to create and manage a Hub.

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

module "hub" {
  source        = "azurerm/resources/azure//modules/pattern_hub"
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
| <a name="provider_http"></a> [http](#provider\_http) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bastion"></a> [bastion](#module\_bastion) | ../bastion_host | n/a |
| <a name="module_bastion_diagnostic_setting"></a> [bastion\_diagnostic\_setting](#module\_bastion\_diagnostic\_setting) | ../monitor_diagnostic_setting | n/a |
| <a name="module_firewall"></a> [firewall](#module\_firewall) | ../firewall | n/a |
| <a name="module_firewall_diagnostic_setting"></a> [firewall\_diagnostic\_setting](#module\_firewall\_diagnostic\_setting) | ../monitor_diagnostic_setting | n/a |
| <a name="module_firewall_palo_alto"></a> [firewall\_palo\_alto](#module\_firewall\_palo\_alto) | ../firewall_palo_alto | n/a |
| <a name="module_firewall_policy"></a> [firewall\_policy](#module\_firewall\_policy) | ../firewall_policy | n/a |
| <a name="module_firewall_workbook"></a> [firewall\_workbook](#module\_firewall\_workbook) | ../firewall_workbook | n/a |
| <a name="module_gateway"></a> [gateway](#module\_gateway) | ../virtual_network_gateway | n/a |
| <a name="module_gateway_diagnostic_setting"></a> [gateway\_diagnostic\_setting](#module\_gateway\_diagnostic\_setting) | ../monitor_diagnostic_setting | n/a |
| <a name="module_key_vault"></a> [key\_vault](#module\_key\_vault) | ../key_vault | n/a |
| <a name="module_key_vault_diagnostic_setting"></a> [key\_vault\_diagnostic\_setting](#module\_key\_vault\_diagnostic\_setting) | ../monitor_diagnostic_setting | n/a |
| <a name="module_locations"></a> [locations](#module\_locations) | ../locations | n/a |
| <a name="module_log_analytics_workspace"></a> [log\_analytics\_workspace](#module\_log\_analytics\_workspace) | ../log_analytics_workspace | n/a |
| <a name="module_public_ip_bastion"></a> [public\_ip\_bastion](#module\_public\_ip\_bastion) | ../public_ip | n/a |
| <a name="module_public_ip_firewall"></a> [public\_ip\_firewall](#module\_public\_ip\_firewall) | ../public_ip | n/a |
| <a name="module_public_ip_gateway"></a> [public\_ip\_gateway](#module\_public\_ip\_gateway) | ../public_ip | n/a |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | ../resource_group | n/a |
| <a name="module_resource_group_management"></a> [resource\_group\_management](#module\_resource\_group\_management) | ../resource_group | n/a |
| <a name="module_route_table_gateway"></a> [route\_table\_gateway](#module\_route\_table\_gateway) | ../route_table | n/a |
| <a name="module_storage_account"></a> [storage\_account](#module\_storage\_account) | ../storage_account | n/a |
| <a name="module_subnet_bastion"></a> [subnet\_bastion](#module\_subnet\_bastion) | ../subnet | n/a |
| <a name="module_subnet_firewall"></a> [subnet\_firewall](#module\_subnet\_firewall) | ../subnet | n/a |
| <a name="module_subnet_gateway"></a> [subnet\_gateway](#module\_subnet\_gateway) | ../subnet | n/a |
| <a name="module_subnet_route_table_association_gateway"></a> [subnet\_route\_table\_association\_gateway](#module\_subnet\_route\_table\_association\_gateway) | ../subnet_route_table_association | n/a |
| <a name="module_user_assigned_identity"></a> [user\_assigned\_identity](#module\_user\_assigned\_identity) | ../user_assigned_identity | n/a |
| <a name="module_virtual_network"></a> [virtual\_network](#module\_virtual\_network) | ../virtual_network | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_firewall_policy_rule_collection_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy_rule_collection_group) | resource |
| [random_integer.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [http_http.ipinfo](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_access_policy_object_ids"></a> [additional\_access\_policy\_object\_ids](#input\_additional\_access\_policy\_object\_ids) | (Optional) An additional Object ID to add to the Key Vault Access Policy. | `list(string)` | `[]` | no |
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | (Required) The address space that is used the Hub. | `list(string)` | n/a | yes |
| <a name="input_asn"></a> [asn](#input\_asn) | (Optional) The ASN of the Gateway. | `number` | `0` | no |
| <a name="input_bastion"></a> [bastion](#input\_bastion) | (Optional) Include a Bastion Host. | `bool` | `true` | no |
| <a name="input_bastion_sku"></a> [bastion\_sku](#input\_bastion\_sku) | (Optional) The SKU of the Bastion Host. | `string` | `"Basic"` | no |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | (Optional) The DNS servers to be used. | `list(string)` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | (Required) The environment of the Hub. | `string` | `"prd"` | no |
| <a name="input_firewall"></a> [firewall](#input\_firewall) | (Optional) Include a Firewall. | `bool` | `true` | no |
| <a name="input_firewall_default_rules"></a> [firewall\_default\_rules](#input\_firewall\_default\_rules) | (Optional) Include the default rules for the Firewall. | `bool` | `true` | no |
| <a name="input_firewall_palo_alto"></a> [firewall\_palo\_alto](#input\_firewall\_palo\_alto) | (Optional) Include a Palo Alto Firewall. | `bool` | `false` | no |
| <a name="input_firewall_sku"></a> [firewall\_sku](#input\_firewall\_sku) | (Optional) The SKU of the Firewall. | `string` | `"Standard"` | no |
| <a name="input_gateway"></a> [gateway](#input\_gateway) | (Optional) Include a Gateway. | `bool` | `true` | no |
| <a name="input_gateway_sku"></a> [gateway\_sku](#input\_gateway\_sku) | (Optional) The SKU of the Gateway. | `string` | `"VpnGw1AZ"` | no |
| <a name="input_gateway_type"></a> [gateway\_type](#input\_gateway\_type) | (Optional) The type of the Gateway. | `string` | `"Vpn"` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | (Optional) The instance count for the Hub. | `string` | `"001"` | no |
| <a name="input_ip_filter"></a> [ip\_filter](#input\_ip\_filter) | (Optional) Include an IP Filter. | `bool` | `false` | no |
| <a name="input_key_vault"></a> [key\_vault](#input\_key\_vault) | (Optional) Include a Key Vault. | `bool` | `true` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location/region where the Hub is created. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_module_tags"></a> [module\_tags](#input\_module\_tags) | (Optional) Include the default tags? | `bool` | `true` | no |
| <a name="input_p2s_vpn"></a> [p2s\_vpn](#input\_p2s\_vpn) | (Optional) Include a Point-to-Site VPN configuration. | `bool` | `false` | no |
| <a name="input_storage_account"></a> [storage\_account](#input\_storage\_account) | (Optional) Include a Storage Account. | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `null` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | (Required) Default workload | `string` | `"hub"` | no |
| <a name="input_workload_management"></a> [workload\_management](#input\_workload\_management) | (Required) Management workload | `string` | `"mgt"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_firewall_policy_id"></a> [firewall\_policy\_id](#output\_firewall\_policy\_id) | The ID of the Firewall Policy. |
| <a name="output_firewall_private_ip_address"></a> [firewall\_private\_ip\_address](#output\_firewall\_private\_ip\_address) | The private IP address of the Firewall. |
| <a name="output_firewall_public_ip_address"></a> [firewall\_public\_ip\_address](#output\_firewall\_public\_ip\_address) | The public IP address of the Firewall. |
| <a name="output_gateway_id"></a> [gateway\_id](#output\_gateway\_id) | The ID of the Gateway. |
| <a name="output_gateway_public_ip_address"></a> [gateway\_public\_ip\_address](#output\_gateway\_public\_ip\_address) | The public IP address of the Gateway. |
| <a name="output_key_vault_id"></a> [key\_vault\_id](#output\_key\_vault\_id) | The ID of the Key Vault. |
| <a name="output_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#output\_log\_analytics\_workspace\_id) | The ID of the Log Analytics Workspace. |
| <a name="output_log_analytics_workspace_workspace_id"></a> [log\_analytics\_workspace\_workspace\_id](#output\_log\_analytics\_workspace\_workspace\_id) | The resource ID of the Log Analytics Workspace. |
| <a name="output_palo_alto_password"></a> [palo\_alto\_password](#output\_palo\_alto\_password) | The password of the Palo Alto Firewall. |
| <a name="output_resource_group_management_name"></a> [resource\_group\_management\_name](#output\_resource\_group\_management\_name) | The name of the management resource group. |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of the resource group of the hub. |
| <a name="output_route_table_name"></a> [route\_table\_name](#output\_route\_table\_name) | The name of the Route Table. |
| <a name="output_storage_account_id"></a> [storage\_account\_id](#output\_storage\_account\_id) | The ID of the Storage Account. |
| <a name="output_virtual_network_id"></a> [virtual\_network\_id](#output\_virtual\_network\_id) | The ID of the virtual network of the hub. |
| <a name="output_virtual_network_name"></a> [virtual\_network\_name](#output\_virtual\_network\_name) | The name of the virtual network of the hub. |
<!-- END_TF_DOCS -->