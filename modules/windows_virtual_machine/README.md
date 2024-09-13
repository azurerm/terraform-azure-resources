<!-- BEGIN_TF_DOCS -->
# Linux Virtual Machine
[![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurerm/resources/azure/latest/submodules/windows_virtual_machine)

Terraform module to create and manage a Winddows Virtual Machine.

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

module "windows_virtual_machine" {
  source              = "azurerm/resources/azure//modules/windows_virtual_machine"
  location            = "westeurope"
  environment         = "dev"
  workload            = "example"
  instance            = "001"
  resource_group_name = module.resource_group.name
  subnet_id           = module.subnet.id
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_agents"></a> [agents](#module\_agents) | ../virtual_machine_extension | n/a |
| <a name="module_dependency_agent"></a> [dependency\_agent](#module\_dependency\_agent) | ../virtual_machine_extension | n/a |
| <a name="module_locations"></a> [locations](#module\_locations) | ../locations | n/a |
| <a name="module_monitor_agent"></a> [monitor\_agent](#module\_monitor\_agent) | ../virtual_machine_extension | n/a |
| <a name="module_naming"></a> [naming](#module\_naming) | ../naming | n/a |
| <a name="module_watcher_agent"></a> [watcher\_agent](#module\_watcher\_agent) | ../virtual_machine_extension | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_network_interface.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_windows_virtual_machine.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) | resource |
| [random_password.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | (Optional) The password of the local administrator to be created on the Virtual Machine. | `string` | `""` | no |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | (Optional) The username of the local administrator to be created on the Virtual Machine. | `string` | `"azureuser"` | no |
| <a name="input_agents"></a> [agents](#input\_agents) | (Optional) A map of agents to install. | <pre>map(object({<br>    publisher                  = string<br>    type                       = string<br>    type_handler_version       = string<br>    automatic_upgrade_enabled  = bool<br>    auto_upgrade_minor_version = bool<br>    settings                   = string<br>  }))</pre> | `{}` | no |
| <a name="input_custom_name"></a> [custom\_name](#input\_custom\_name) | (Optional) The name of the Virtual Network. | `string` | `""` | no |
| <a name="input_custom_network_interface_name"></a> [custom\_network\_interface\_name](#input\_custom\_network\_interface\_name) | (Optional) The name of the Network Interface. | `string` | `""` | no |
| <a name="input_custom_os_disk_name"></a> [custom\_os\_disk\_name](#input\_custom\_os\_disk\_name) | (Optional) The name of the OS Disk. | `string` | `""` | no |
| <a name="input_dependency_agent_auto_upgrade_minor_version"></a> [dependency\_agent\_auto\_upgrade\_minor\_version](#input\_dependency\_agent\_auto\_upgrade\_minor\_version) | (Optional) Should the extension be automatically upgraded across minor versions when Azure updates the extension? | `bool` | `true` | no |
| <a name="input_dependency_agent_automatic_upgrade_enabled"></a> [dependency\_agent\_automatic\_upgrade\_enabled](#input\_dependency\_agent\_automatic\_upgrade\_enabled) | (Optional) Should the extension be automatically upgraded when a new version is published? | `bool` | `true` | no |
| <a name="input_dependency_agent_publisher"></a> [dependency\_agent\_publisher](#input\_dependency\_agent\_publisher) | (Optional) The name of the extension publisher. | `string` | `"Microsoft.Azure.Monitoring.DependencyAgent"` | no |
| <a name="input_dependency_agent_type"></a> [dependency\_agent\_type](#input\_dependency\_agent\_type) | (Optional) The type of the extension. | `string` | `"DependencyAgentWindows"` | no |
| <a name="input_dependency_agent_type_handler_version"></a> [dependency\_agent\_type\_handler\_version](#input\_dependency\_agent\_type\_handler\_version) | (Optional) Specifies the version of the script handler. | `string` | `"9.10"` | no |
| <a name="input_enable_accelerated_networking"></a> [enable\_accelerated\_networking](#input\_enable\_accelerated\_networking) | (Optional) Should Accelerated Networking be enabled on the Network Interface? | `bool` | `false` | no |
| <a name="input_enable_ip_forwarding"></a> [enable\_ip\_forwarding](#input\_enable\_ip\_forwarding) | (Optional) Should IP Forwarding be enabled on the Network Interface? | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | (Optional) The environment of the Virtual Network. | `string` | `""` | no |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | (Optional) A list of Managed Service Identity IDs which should be assigned to the Virtual Machine. | `list(string)` | `[]` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | (Optional) The type of Managed Service Identity which should be used for the Virtual Machine. | `string` | `"None"` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | (Optional) The instance count for the Virtual Network. | `string` | `""` | no |
| <a name="input_ip_configuration_name"></a> [ip\_configuration\_name](#input\_ip\_configuration\_name) | (Optional) The name of the IP Configuration. | `string` | `"ipconfig"` | no |
| <a name="input_license_type"></a> [license\_type](#input\_license\_type) | (Optional) The license type which should be used for the Virtual Machine. | `string` | `"None"` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location/region where the Virtual Network is created. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_module_tags"></a> [module\_tags](#input\_module\_tags) | (Optional) Include the default tags? | `bool` | `true` | no |
| <a name="input_monitor_agent"></a> [monitor\_agent](#input\_monitor\_agent) | (Optional) Install the Azure Monitor Agent? | `bool` | `false` | no |
| <a name="input_monitor_agent_auto_upgrade_minor_version"></a> [monitor\_agent\_auto\_upgrade\_minor\_version](#input\_monitor\_agent\_auto\_upgrade\_minor\_version) | (Optional) Should the extension be automatically upgraded across minor versions when Azure updates the extension? | `bool` | `true` | no |
| <a name="input_monitor_agent_automatic_upgrade_enabled"></a> [monitor\_agent\_automatic\_upgrade\_enabled](#input\_monitor\_agent\_automatic\_upgrade\_enabled) | (Optional) Should the extension be automatically upgraded when a new version is published? | `bool` | `true` | no |
| <a name="input_monitor_agent_publisher"></a> [monitor\_agent\_publisher](#input\_monitor\_agent\_publisher) | (Optional) The name of the extension publisher. | `string` | `"Microsoft.Azure.Monitor"` | no |
| <a name="input_monitor_agent_type"></a> [monitor\_agent\_type](#input\_monitor\_agent\_type) | (Optional) The type of the extension. | `string` | `"AzureMonitorWindowsAgent"` | no |
| <a name="input_monitor_agent_type_handler_version"></a> [monitor\_agent\_type\_handler\_version](#input\_monitor\_agent\_type\_handler\_version) | (Optional) Specifies the version of the script handler. | `string` | `"1.22"` | no |
| <a name="input_os_disk_caching"></a> [os\_disk\_caching](#input\_os\_disk\_caching) | (Optional) The Type of Caching which should be used for the Virtual Machine's OS Disk. | `string` | `"ReadWrite"` | no |
| <a name="input_os_disk_size"></a> [os\_disk\_size](#input\_os\_disk\_size) | (Optional) The size of the OS Disk which should be attached to the Virtual Machine. | `number` | `128` | no |
| <a name="input_os_disk_type"></a> [os\_disk\_type](#input\_os\_disk\_type) | (Optional) The type of OS Disk which should be attached to the Virtual Machine. | `string` | `"Standard_LRS"` | no |
| <a name="input_patch_assessment_mode"></a> [patch\_assessment\_mode](#input\_patch\_assessment\_mode) | (Optional) The patching configuration of the Virtual Machine. | `string` | `"ImageDefault"` | no |
| <a name="input_patch_mode"></a> [patch\_mode](#input\_patch\_mode) | (Optional) The patching configuration of the Virtual Machine. | `string` | `"AutomaticByPlatform"` | no |
| <a name="input_private_ip_address"></a> [private\_ip\_address](#input\_private\_ip\_address) | (Optional) The Private IP Address which should be used for this Virtual Machine. | `string` | `null` | no |
| <a name="input_private_ip_address_allocation"></a> [private\_ip\_address\_allocation](#input\_private\_ip\_address\_allocation) | (Optional) The allocation method of the Private IP Address. | `string` | `"Dynamic"` | no |
| <a name="input_random_password_length"></a> [random\_password\_length](#input\_random\_password\_length) | (Optional) The length of the auto-generated password. | `number` | `16` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the Virtual Network. | `string` | n/a | yes |
| <a name="input_size"></a> [size](#input\_size) | (Optional) The size of the Virtual Machine. | `string` | `"Standard_B2s"` | no |
| <a name="input_source_image_reference_offer"></a> [source\_image\_reference\_offer](#input\_source\_image\_reference\_offer) | (Optional) The offer of the image which should be used for the Virtual Machine. | `string` | `"WindowsServer"` | no |
| <a name="input_source_image_reference_publisher"></a> [source\_image\_reference\_publisher](#input\_source\_image\_reference\_publisher) | (Optional) The publisher of the image which should be used for the Virtual Machine. | `string` | `"MicrosoftWindowsServer"` | no |
| <a name="input_source_image_reference_sku"></a> [source\_image\_reference\_sku](#input\_source\_image\_reference\_sku) | (Optional) The SKU of the image which should be used for the Virtual Machine. | `string` | `"2022-datacenter-azure-edition-hotpatch"` | no |
| <a name="input_source_image_reference_version"></a> [source\_image\_reference\_version](#input\_source\_image\_reference\_version) | (Optional) The version of the image which should be used for the Virtual Machine. | `string` | `"latest"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | (Required) The ID of the Subnet which should be used with the Network Interface. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `null` | no |
| <a name="input_vm_agent_platform_updates_enabled"></a> [vm\_agent\_platform\_updates\_enabled](#input\_vm\_agent\_platform\_updates\_enabled) | (Optional) Should the VM Agent be enabled for the Virtual Machine? | `bool` | `true` | no |
| <a name="input_watcher_agent"></a> [watcher\_agent](#input\_watcher\_agent) | (Optional) Install the Azure Monitor Agent? | `bool` | `false` | no |
| <a name="input_watcher_agent_auto_upgrade_minor_version"></a> [watcher\_agent\_auto\_upgrade\_minor\_version](#input\_watcher\_agent\_auto\_upgrade\_minor\_version) | (Optional) Should the extension be automatically upgraded across minor versions when Azure updates the extension? | `bool` | `true` | no |
| <a name="input_watcher_agent_automatic_upgrade_enabled"></a> [watcher\_agent\_automatic\_upgrade\_enabled](#input\_watcher\_agent\_automatic\_upgrade\_enabled) | (Optional) Should the extension be automatically upgraded when a new version is published? | `bool` | `true` | no |
| <a name="input_watcher_agent_publisher"></a> [watcher\_agent\_publisher](#input\_watcher\_agent\_publisher) | (Optional) The name of the extension publisher. | `string` | `"Microsoft.Azure.NetworkWatcher"` | no |
| <a name="input_watcher_agent_type"></a> [watcher\_agent\_type](#input\_watcher\_agent\_type) | (Optional) The type of the extension. | `string` | `"NetworkWatcherAgentWindows"` | no |
| <a name="input_watcher_agent_type_handler_version"></a> [watcher\_agent\_type\_handler\_version](#input\_watcher\_agent\_type\_handler\_version) | (Optional) Specifies the version of the script handler. | `string` | `"1.4"` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | (Optional) The usage or application of the Virtual Network. | `string` | `""` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | (Optional) The Availability Zone which the Virtual Machine should be allocated in. | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_password"></a> [admin\_password](#output\_admin\_password) | The password of the windows Virtual Machine. |
| <a name="output_admin_username"></a> [admin\_username](#output\_admin\_username) | The username of the windows Virtual Machine. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the windows Virtual Machine. |
| <a name="output_name"></a> [name](#output\_name) | The name of the windows Virtual Machine. |
| <a name="output_private_ip_address"></a> [private\_ip\_address](#output\_private\_ip\_address) | The private IP address of the windows Virtual Machine. |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of the resource group in which the windows Virtual Machine is created. |
| <a name="output_source_image_reference_offer"></a> [source\_image\_reference\_offer](#output\_source\_image\_reference\_offer) | The offer of the source image used to create the Linux Virtual Machine. |
<!-- END_TF_DOCS -->