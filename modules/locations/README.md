<!-- BEGIN_TF_DOCS -->
# Locations
[![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurerm/resources/azure/latest/submodules/locations)

This Terraform module is designed to provide information on Azure locations.

It provides for an Azure location name or display name : name, display name, regional display name, short name and paired region name.

Please refer to the [locations.json](locations.json) file for available locations. The list was build based on this command line :   
```
az account list-locations --query "[].{regionalDisplayName: regionalDisplayName, name: name, displayName: displayName, pairedRegionName: metadata.pairedRegion[0].name}"
```

Short name is based on this list : [Geo-code mapping](https://learn.microsoft.com/en-us/azure/backup/scripts/geo-code-list)

## Example

```hcl
module "azure_location" {
  source   = "../"
  location = "West Europe"
}

output "location" {
  value = module.azure_location.location
}
# location                       = {
#     display_name          = "West Europe"
#     name                  = "westeurope"
#     paired_region_name    = "northeurope"
#     regional_display_name = "(Europe) West Europe"
#     short_name            = "we"
# }

module "azure_fake_location" {
  source   = "../"
  location = "Test Europe"
}

output "fake_location" {
  value = module.azure_fake_location.location
}
# location = "none"
```

## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | (Required) The location/region name or displayName to get information. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_display_name"></a> [display\_name](#output\_display\_name) | Display name of the location. Return 'none' if location is not found. |
| <a name="output_location"></a> [location](#output\_location) | Map of information for the location. Return 'none' if location is not found. |
| <a name="output_name"></a> [name](#output\_name) | Standard name of the location. Return 'none' if location is not found. |
| <a name="output_paired_region_name"></a> [paired\_region\_name](#output\_paired\_region\_name) | Paired region name of the location. Return 'none' if location is not found and null if there is no paired region name for this location. |
| <a name="output_regional_display_name"></a> [regional\_display\_name](#output\_regional\_display\_name) | Regional display name of the location. Return 'none' if location is not found. |
| <a name="output_short_name"></a> [short\_name](#output\_short\_name) | Short name of the location. Return 'none' if location is not found and null if there is no short name for this location. |
<!-- END_TF_DOCS -->