<!-- BEGIN_TF_DOCS -->
# Hub & Spoke
[![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurerm/resources/azure/latest/submodules/pattern_hub_and_spoke)

Terraform module to create and manage a Hub & Spoke.

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

module "hub_and_spoke" {
  source            = "azurerm/resources/azure//modules/pattern_hub_and_spoke"
  location          = "westeurope"
  address_space_hub = ["10.100.0.0/24"]
  address_space_spokes = [
    {
      workload      = "app1"
      environment   = "dev"
      instance      = "001"
      address_space = ["10.100.1.0/24"]
    },
    {
      workload      = "app2"
      environment   = "dev"
      instance      = "001"
      address_space = ["10.100.2.0/24"]
    },
    {
      workload      = "app1"
      environment   = "prd"
      instance      = "001"
      address_space = ["10.110.1.0/24"]
    },
    {
      workload      = "app2"
      environment   = "prd"
      instance      = "001"
      address_space = ["10.110.2.0/24"]
    }
  ]
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_restapi"></a> [restapi](#provider\_restapi) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_backup_policy_vm_development"></a> [backup\_policy\_vm\_development](#module\_backup\_policy\_vm\_development) | ../backup_policy_vm | n/a |
| <a name="module_backup_policy_vm_production"></a> [backup\_policy\_vm\_production](#module\_backup\_policy\_vm\_production) | ../backup_policy_vm | n/a |
| <a name="module_data_collection_endpoint_association"></a> [data\_collection\_endpoint\_association](#module\_data\_collection\_endpoint\_association) | ../monitor_data_collection_rule_association | n/a |
| <a name="module_data_collection_rule_association"></a> [data\_collection\_rule\_association](#module\_data\_collection\_rule\_association) | ../monitor_data_collection_rule_association | n/a |
| <a name="module_hub"></a> [hub](#module\_hub) | ../pattern_hub | n/a |
| <a name="module_key_vault_palo_alto_secret"></a> [key\_vault\_palo\_alto\_secret](#module\_key\_vault\_palo\_alto\_secret) | ../key_vault_secret | n/a |
| <a name="module_key_vault_secret"></a> [key\_vault\_secret](#module\_key\_vault\_secret) | ../key_vault_secret | n/a |
| <a name="module_key_vault_secret_jumphost"></a> [key\_vault\_secret\_jumphost](#module\_key\_vault\_secret\_jumphost) | ../key_vault_secret | n/a |
| <a name="module_locations"></a> [locations](#module\_locations) | ../locations | n/a |
| <a name="module_naming"></a> [naming](#module\_naming) | ../naming | n/a |
| <a name="module_pattern_monitoring"></a> [pattern\_monitoring](#module\_pattern\_monitoring) | ../pattern_monitoring | n/a |
| <a name="module_recovery_services_vault"></a> [recovery\_services\_vault](#module\_recovery\_services\_vault) | ../recovery_services_vault | n/a |
| <a name="module_route_to_spoke"></a> [route\_to\_spoke](#module\_route\_to\_spoke) | ../route | n/a |
| <a name="module_route_to_spoke_dmz"></a> [route\_to\_spoke\_dmz](#module\_route\_to\_spoke\_dmz) | ../route | n/a |
| <a name="module_route_to_spoke_dns"></a> [route\_to\_spoke\_dns](#module\_route\_to\_spoke\_dns) | ../route | n/a |
| <a name="module_route_to_spoke_jumphost"></a> [route\_to\_spoke\_jumphost](#module\_route\_to\_spoke\_jumphost) | ../route | n/a |
| <a name="module_spoke"></a> [spoke](#module\_spoke) | ../pattern_spoke | n/a |
| <a name="module_spoke_ai"></a> [spoke\_ai](#module\_spoke\_ai) | ../pattern_spoke_ai | n/a |
| <a name="module_spoke_dmz"></a> [spoke\_dmz](#module\_spoke\_dmz) | ../pattern_spoke_dmz | n/a |
| <a name="module_spoke_dns"></a> [spoke\_dns](#module\_spoke\_dns) | ../pattern_spoke_dns | n/a |
| <a name="module_spoke_jumphost"></a> [spoke\_jumphost](#module\_spoke\_jumphost) | ../pattern_spoke_jumphost | n/a |
| <a name="module_spokes_default_route"></a> [spokes\_default\_route](#module\_spokes\_default\_route) | ../route | n/a |
| <a name="module_spokes_single_route_table"></a> [spokes\_single\_route\_table](#module\_spokes\_single\_route\_table) | ../route_table | n/a |
| <a name="module_virtual_network_peerings"></a> [virtual\_network\_peerings](#module\_virtual\_network\_peerings) | ../virtual_network_peerings | n/a |
| <a name="module_virtual_network_peerings_ai"></a> [virtual\_network\_peerings\_ai](#module\_virtual\_network\_peerings\_ai) | ../virtual_network_peerings | n/a |
| <a name="module_virtual_network_peerings_dmz"></a> [virtual\_network\_peerings\_dmz](#module\_virtual\_network\_peerings\_dmz) | ../virtual_network_peerings | n/a |
| <a name="module_virtual_network_peerings_dns"></a> [virtual\_network\_peerings\_dns](#module\_virtual\_network\_peerings\_dns) | ../virtual_network_peerings | n/a |
| <a name="module_virtual_network_peerings_jumphost"></a> [virtual\_network\_peerings\_jumphost](#module\_virtual\_network\_peerings\_jumphost) | ../virtual_network_peerings | n/a |
| <a name="module_virtual_network_peerings_monitoring"></a> [virtual\_network\_peerings\_monitoring](#module\_virtual\_network\_peerings\_monitoring) | ../virtual_network_peerings | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_backup_protected_vm.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_protected_vm) | resource |
| [azurerm_network_connection_monitor.external](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_connection_monitor) | resource |
| [azurerm_network_connection_monitor.internal](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_connection_monitor) | resource |
| [azurerm_network_watcher_flow_log.hub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_watcher_flow_log) | resource |
| [azurerm_network_watcher_flow_log.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_watcher_flow_log) | resource |
| [restapi_object.create_datasource](https://registry.terraform.io/providers/mastercard/restapi/latest/docs/resources/object) | resource |
| [restapi_object.create_index](https://registry.terraform.io/providers/mastercard/restapi/latest/docs/resources/object) | resource |
| [restapi_object.create_indexer](https://registry.terraform.io/providers/mastercard/restapi/latest/docs/resources/object) | resource |
| [azurerm_network_watcher.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/network_watcher) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_access_policy_object_ids"></a> [additional\_access\_policy\_object\_ids](#input\_additional\_access\_policy\_object\_ids) | (Optional) An additional Object ID to add to the Key Vault Access Policy. | `list(string)` | `[]` | no |
| <a name="input_address_space_hub"></a> [address\_space\_hub](#input\_address\_space\_hub) | (Required) The address space that is used the Hub. | `list(string)` | n/a | yes |
| <a name="input_address_space_spoke_ai"></a> [address\_space\_spoke\_ai](#input\_address\_space\_spoke\_ai) | (Optional) The address space that is used the Virtual Network. | `list(string)` | `null` | no |
| <a name="input_address_space_spoke_dmz"></a> [address\_space\_spoke\_dmz](#input\_address\_space\_spoke\_dmz) | (Optional) The address space that is used the Virtual Network. | `list(string)` | `null` | no |
| <a name="input_address_space_spoke_dns"></a> [address\_space\_spoke\_dns](#input\_address\_space\_spoke\_dns) | (Optional) The address space that is used the Virtual Network. | `list(string)` | `null` | no |
| <a name="input_address_space_spoke_jumphost"></a> [address\_space\_spoke\_jumphost](#input\_address\_space\_spoke\_jumphost) | (Optional) The address space that is used the Virtual Network. | `list(string)` | `null` | no |
| <a name="input_address_space_spoke_private_monitoring"></a> [address\_space\_spoke\_private\_monitoring](#input\_address\_space\_spoke\_private\_monitoring) | (Optional) The address space that is used the Virtual Network. | `list(string)` | `null` | no |
| <a name="input_address_space_spokes"></a> [address\_space\_spokes](#input\_address\_space\_spokes) | (Optional) The address space that is used the Virtual Network. | <pre>list(object({<br>    workload         = string<br>    environment      = string<br>    instance         = string<br>    address_space    = list(string)<br>    virtual_machines = optional(bool, true)<br>  }))</pre> | `[]` | no |
| <a name="input_backup"></a> [backup](#input\_backup) | (Optional) Include a backup configuration for the Virtual Machine. | `bool` | `false` | no |
| <a name="input_bastion"></a> [bastion](#input\_bastion) | (Optional) Include a Bastion Host. | `bool` | `true` | no |
| <a name="input_bastion_sku"></a> [bastion\_sku](#input\_bastion\_sku) | (Optional) The SKU of the Bastion Host. | `string` | `"Basic"` | no |
| <a name="input_connection_monitor"></a> [connection\_monitor](#input\_connection\_monitor) | (Optional) Include a Network Watcher Connection Monitor. | `bool` | `false` | no |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | (Optional) The DNS servers to be used with the Hub. | `list(string)` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | (Optional) The environment of the Hub. | `string` | `"prd"` | no |
| <a name="input_firewall"></a> [firewall](#input\_firewall) | (Optional) Include a Firewall. | `bool` | `true` | no |
| <a name="input_firewall_palo_alto"></a> [firewall\_palo\_alto](#input\_firewall\_palo\_alto) | (Optional) Include a Palo Alto Firewall. | `bool` | `false` | no |
| <a name="input_firewall_sku"></a> [firewall\_sku](#input\_firewall\_sku) | (Optional) The SKU of the Firewall. | `string` | `"Standard"` | no |
| <a name="input_gateway"></a> [gateway](#input\_gateway) | (Optional) Include a Gateway. | `bool` | `true` | no |
| <a name="input_gateway_sku"></a> [gateway\_sku](#input\_gateway\_sku) | (Optional) The SKU of the Gateway. | `string` | `"VpnGw1AZ"` | no |
| <a name="input_gateway_type"></a> [gateway\_type](#input\_gateway\_type) | (Optional) The type of the Gateway. | `string` | `"Vpn"` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | (Optional) The instance count for the Hub. | `string` | `"001"` | no |
| <a name="input_ip_filter"></a> [ip\_filter](#input\_ip\_filter) | (Optional) Include an IP Filter. | `bool` | `true` | no |
| <a name="input_key_vault"></a> [key\_vault](#input\_key\_vault) | (Optional) Include a Key Vault. | `bool` | `true` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location/region where the Virtual Network is created. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_module_tags"></a> [module\_tags](#input\_module\_tags) | (Optional) Include the default tags? | `bool` | `true` | no |
| <a name="input_network_security_group"></a> [network\_security\_group](#input\_network\_security\_group) | (Optional) Include a Network Security Group with Flow Log. | `bool` | `false` | no |
| <a name="input_p2s_vpn"></a> [p2s\_vpn](#input\_p2s\_vpn) | (Optional) Include a Point-to-Site VPN configuration. | `bool` | `false` | no |
| <a name="input_private_monitoring"></a> [private\_monitoring](#input\_private\_monitoring) | (Optional) Include a Private Monitoring. | `bool` | `false` | no |
| <a name="input_private_paas"></a> [private\_paas](#input\_private\_paas) | (Optional) Close any public access to the PaaS services (private connectivity is required). | `bool` | `false` | no |
| <a name="input_spoke_ai"></a> [spoke\_ai](#input\_spoke\_ai) | (Optional) Include a DMZ Spoke. | `bool` | `false` | no |
| <a name="input_spoke_dmz"></a> [spoke\_dmz](#input\_spoke\_dmz) | (Optional) Include a DMZ Spoke. | `bool` | `false` | no |
| <a name="input_spoke_dns"></a> [spoke\_dns](#input\_spoke\_dns) | (Optional) Include a Spoke DNS. | `bool` | `false` | no |
| <a name="input_spoke_jumphost"></a> [spoke\_jumphost](#input\_spoke\_jumphost) | (Optional) Include a Spoke Jump Host. | `bool` | `false` | no |
| <a name="input_spokes_single_route_table"></a> [spokes\_single\_route\_table](#input\_spokes\_single\_route\_table) | (Optional) Use a single Route Table for all the Applications Spokes. | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `null` | no |
| <a name="input_update_management"></a> [update\_management](#input\_update\_management) | (Optional) Include Update Management for the Virtual Machine. | `bool` | `false` | no |
| <a name="input_web_application_firewall"></a> [web\_application\_firewall](#input\_web\_application\_firewall) | (Optional) Include a WAF. | `bool` | `false` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | (Optional) The usage of the Hub. | `string` | `"hub"` | no |
| <a name="input_workload_management"></a> [workload\_management](#input\_workload\_management) | (Required) Management workload | `string` | `"mgt"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_firewall_public_ip_address"></a> [firewall\_public\_ip\_address](#output\_firewall\_public\_ip\_address) | The public IP address of the Firewall. |
| <a name="output_gateway_id"></a> [gateway\_id](#output\_gateway\_id) | The ID of the Gateway. |
| <a name="output_gateway_public_ip_address"></a> [gateway\_public\_ip\_address](#output\_gateway\_public\_ip\_address) | The public IP address of the Gateway. |
| <a name="output_hub_resource_group_name"></a> [hub\_resource\_group\_name](#output\_hub\_resource\_group\_name) | The name of the resource group of the spoke. |
| <a name="output_key_vault_id"></a> [key\_vault\_id](#output\_key\_vault\_id) | The ID of the Key Vault. |
| <a name="output_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#output\_log\_analytics\_workspace\_id) | The ID of the Log Analytics Workspace to log Application Gateway. |
<!-- END_TF_DOCS -->