<!-- BEGIN_TF_DOCS -->
# Backup Policy VM
[![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurerm/resources/azure/latest/submodules/backup_policy_vm)

Terraform module to create and manage a Backup Policy VM.

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
  workload    = "mgt"
  instance    = "001"
}

module "recovery_services_vault" {
  source              = "./modules/recovery_services_vault"
  location            = module.resource_group.location
  environment         = "prd"
  workload            = "mgt"
  resource_group_name = module.resource_group.name
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
| [azurerm_backup_policy_vm.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_vm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_frequency"></a> [backup\_frequency](#input\_backup\_frequency) | (Optional) The frequency of the backup policy. | `string` | `"Daily"` | no |
| <a name="input_backup_time"></a> [backup\_time](#input\_backup\_time) | (Optional) The time of the backup policy. | `string` | `"01:00"` | no |
| <a name="input_custom_name"></a> [custom\_name](#input\_custom\_name) | (Optional) The name of the Recovery Services Vault. | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | (Optional) The environment of the Recovery Services Vault. | `string` | `""` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | (Optional) The instance count for the Recovery Services Vault. | `string` | `""` | no |
| <a name="input_instant_restore_retention_days"></a> [instant\_restore\_retention\_days](#input\_instant\_restore\_retention\_days) | (Optional) The number of days to retain Instant Restore snapshots. | `number` | `2` | no |
| <a name="input_location"></a> [location](#input\_location) | (Optional) The location/region where the Recovery Services Vault is created. Changing this forces a new resource to be created. | `string` | `""` | no |
| <a name="input_recovery_vault_name"></a> [recovery\_vault\_name](#input\_recovery\_vault\_name) | (Required) The name of the Recovery Services Vault. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group where the Recovery Services Vault is located. | `string` | n/a | yes |
| <a name="input_retention_daily_count"></a> [retention\_daily\_count](#input\_retention\_daily\_count) | (Optional) The number of daily backups to retain. | `number` | `14` | no |
| <a name="input_timezone"></a> [timezone](#input\_timezone) | (Optional) The timezone of the backup policy. | `string` | `"UTC"` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | (Optional) The usage or application of the Recovery Services Vault. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Backup Policy VM. |
| <a name="output_name"></a> [name](#output\_name) | The name of the Backup Policy VM. |
<!-- END_TF_DOCS -->