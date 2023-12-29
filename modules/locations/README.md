# Azure locations module

This Terraform module is designed to provide information on Azure locations.

It provides for an Azure location name or display name : name, display name, regional display name, short name and paired region name.

Please refer to the [locations.json](locations.json) file for available locations. The list was build based on this command line :   
```
az account list-locations --query "[].{regionalDisplayName: regionalDisplayName, name: name, displayName: displayName, pairedRegionName: metadata.pairedRegion[0].name}"
```

Short name is based on this list : [Geo-code mapping
](https://learn.microsoft.com/en-us/azure/backup/scripts/geo-code-list)

## Usage

```
module "azure_location" {
  source  = "azurerm/locations/azure"
  version = "x.x.x"

  location = "West Europe"
}
```

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| location | The location/region name or displayName to get information. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| location | Map of information for the location. Return 'none' if location is not found. |
| name | Standard name of the location. Return 'none' if location is not found. |
| display_name | Display name of the location. Return 'none' if location is not found. |
| short_name | Short name of the location. Return 'none' if location is not found and null if there is no short name for this location. |
| regional_display_name | Regional display name of the location. Return 'none' if location is not found. |
| paired_region_name | Paired region name of the location. Return 'none' if location is not found and null if there is no paired region name for this location.  |


## Related documentation

[Azure regions](https://azure.microsoft.com/en-us/global-infrastructure/regions/)  
[Azure Geo-code mapping](https://learn.microsoft.com/en-us/azure/backup/scripts/geo-code-list)  
[Terrafomr modules](https://developer.hashicorp.com/terraform/registry/modules/publish)  
[Terraform Best Practices](https://www.terraform-best-practices.com/)  