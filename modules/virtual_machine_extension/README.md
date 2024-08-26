<!-- BEGIN_TF_DOCS -->
# Virtual Machine Extension
[![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurerm/resources/azure/latest/submodules/virtual_machine_extension)

Terraform module to create and manage a Virtual Machine Extension.

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

module "monitor_agent" {
  source                     = "azurerm/resources/azure//modules/virtual_machine_extension"
  virtual_machine_id         = azurerm_windows_virtual_machine.this.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorWindowsAgent"
  type_handler_version       = "1.22"
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = true
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_virtual_machine_extension.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [time_sleep.wait](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_upgrade_minor_version"></a> [auto\_upgrade\_minor\_version](#input\_auto\_upgrade\_minor\_version) | (Optional) Should the extension be automatically upgraded across minor versions when Azure updates the extension? | `bool` | `false` | no |
| <a name="input_automatic_upgrade_enabled"></a> [automatic\_upgrade\_enabled](#input\_automatic\_upgrade\_enabled) | (Optional) Should the extension be automatically upgraded when a new version is published? | `bool` | `false` | no |
| <a name="input_custom_name"></a> [custom\_name](#input\_custom\_name) | (Optional) The name of the Virtual Network. | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | (Optional) The environment of the Virtual Network. | `string` | `""` | no |
| <a name="input_module_tags"></a> [module\_tags](#input\_module\_tags) | (Optional) Include the default tags? | `bool` | `true` | no |
| <a name="input_publisher"></a> [publisher](#input\_publisher) | (Required) The name of the extension publisher. | `string` | n/a | yes |
| <a name="input_settings"></a> [settings](#input\_settings) | (Optional) A JSON string containing private configuration for the extension. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `null` | no |
| <a name="input_time_sleep"></a> [time\_sleep](#input\_time\_sleep) | (Optional) The time to sleep before the next module. | `string` | `"180s"` | no |
| <a name="input_type"></a> [type](#input\_type) | (Required) The type of the extension. | `string` | n/a | yes |
| <a name="input_type_handler_version"></a> [type\_handler\_version](#input\_type\_handler\_version) | (Required) Specifies the version of the script handler. | `string` | n/a | yes |
| <a name="input_virtual_machine_id"></a> [virtual\_machine\_id](#input\_virtual\_machine\_id) | (Required) The ID of the Virtual Machine to which the Extension should be added. | `string` | n/a | yes |
| <a name="input_workload"></a> [workload](#input\_workload) | (Optional) The usage or application of the Virtual Network. | `string` | `""` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->