<!-- BEGIN_TF_DOCS -->
# Maintenance Configuration
[![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurerm/resources/azure/latest/submodules/maintenance_configuration)

Terraform module to create and manage a Maintenance Configuration.

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
| [azurerm_maintenance_configuration.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/maintenance_configuration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_name"></a> [custom\_name](#input\_custom\_name) | (Optional) The name of the Maintenance Configuration. | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | (Optional) The environment of the Maintenance Configuration. | `string` | `""` | no |
| <a name="input_in_guest_user_patch_mode"></a> [in\_guest\_user\_patch\_mode](#input\_in\_guest\_user\_patch\_mode) | (Optional) The in-guest user patch mode of the Maintenance Configuration. | `string` | `"User"` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | (Optional) The instance count for the Maintenance Configuration. | `string` | `""` | no |
| <a name="input_linux_classifications_to_include"></a> [linux\_classifications\_to\_include](#input\_linux\_classifications\_to\_include) | (Optional) The classification of the Linux patches. | `list(string)` | <pre>[<br>  "Critical",<br>  "Security",<br>  "Other"<br>]</pre> | no |
| <a name="input_linux_package_names_mask_to_exclude"></a> [linux\_package\_names\_mask\_to\_exclude](#input\_linux\_package\_names\_mask\_to\_exclude) | (Optional) The excluded patches for the Linux patches. | `list(string)` | `[]` | no |
| <a name="input_linux_package_names_mask_to_include"></a> [linux\_package\_names\_mask\_to\_include](#input\_linux\_package\_names\_mask\_to\_include) | (Optional) The included patches for the Linux patches. | `list(string)` | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location/region where the Resource Group is created. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_module_tags"></a> [module\_tags](#input\_module\_tags) | (Optional) Include the default tags? | `bool` | `true` | no |
| <a name="input_reboot"></a> [reboot](#input\_reboot) | (Optional) Reboot the system after the patches are installed. | `string` | `"Never"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the Maintenance Configuration. | `string` | n/a | yes |
| <a name="input_scope"></a> [scope](#input\_scope) | (Required) The scope of the Maintenance Configuration. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `null` | no |
| <a name="input_window_duration"></a> [window\_duration](#input\_window\_duration) | (Optional) The duration of the Maintenance Configuration. | `string` | `"03:00"` | no |
| <a name="input_window_expiration_date_time"></a> [window\_expiration\_date\_time](#input\_window\_expiration\_date\_time) | (Optional) The end date and time of the Maintenance Configuration. | `string` | `""` | no |
| <a name="input_window_recur_every"></a> [window\_recur\_every](#input\_window\_recur\_every) | (Optional) The recurrence of the Maintenance Configuration. | `string` | `"1Week Monday"` | no |
| <a name="input_window_start_date_time"></a> [window\_start\_date\_time](#input\_window\_start\_date\_time) | (Required) The start date and time of the Maintenance Configuration. | `string` | n/a | yes |
| <a name="input_window_time_zone"></a> [window\_time\_zone](#input\_window\_time\_zone) | (Optional) The time zone of the Maintenance Configuration. | `string` | `"Romance Standard Time"` | no |
| <a name="input_windows_classifications_to_include"></a> [windows\_classifications\_to\_include](#input\_windows\_classifications\_to\_include) | (Optional) The classification of the Windows patches. | `list(string)` | <pre>[<br>  "Critical",<br>  "Security",<br>  "UpdateRollup",<br>  "FeaturePack",<br>  "Updates",<br>  "Definition"<br>]</pre> | no |
| <a name="input_windows_kb_numbers_to_exclude"></a> [windows\_kb\_numbers\_to\_exclude](#input\_windows\_kb\_numbers\_to\_exclude) | (Optional) The excluded patches for the Windows patches. | `list(string)` | `[]` | no |
| <a name="input_windows_kb_numbers_to_include"></a> [windows\_kb\_numbers\_to\_include](#input\_windows\_kb\_numbers\_to\_include) | (Optional) The included patches for the Windows patches. | `list(string)` | `[]` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | (Optional) The usage or application of the Maintenance Configuration. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Maintenance Configuration. |
<!-- END_TF_DOCS -->