<!-- BEGIN_TF_DOCS -->
# AI Services
[![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurerm/resources/azure/latest/submodules/key_vault)

Terraform module to create and manage a AI Services.

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
| <a name="module_locations"></a> [locations](#module\_locations) | ../locations | n/a |
| <a name="module_naming"></a> [naming](#module\_naming) | ../naming | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_ai_services.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/ai_services) | resource |
| [random_integer.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_name"></a> [custom\_name](#input\_custom\_name) | (Optional) The name of the Virtual Network. | `string` | `""` | no |
| <a name="input_custom_subdomain_name"></a> [custom\_subdomain\_name](#input\_custom\_subdomain\_name) | (Optional) The custom subdomain name of the AI Services. | `string` | `null` | no |
| <a name="input_default_location"></a> [default\_location](#input\_default\_location) | (Optional) The default location of the AI Services. | `string` | `"swedencentral"` | no |
| <a name="input_deployment_availability"></a> [deployment\_availability](#input\_deployment\_availability) | (Optional) The deployment availability of the AI Services. | `list(string)` | <pre>[<br>  "australiaeast",<br>  "brazilsouth",<br>  "canadaeast",<br>  "eastus",<br>  "eastus2",<br>  "francecentral",<br>  "germanywestcentral",<br>  "japaneast",<br>  "koreacentral",<br>  "northcentralus",<br>  "norwayeast",<br>  "polandcentral",<br>  "southafricanorth",<br>  "southcentralus",<br>  "southindia",<br>  "swedencentral",<br>  "switzerlandnorth",<br>  "switzerlandwest",<br>  "uksouth",<br>  "westeurope",<br>  "westus",<br>  "westus3"<br>]</pre> | no |
| <a name="input_environment"></a> [environment](#input\_environment) | (Optional) The environment of the Virtual Network. | `string` | `""` | no |
| <a name="input_fqdns"></a> [fqdns](#input\_fqdns) | (Optional) The FQDNs of the AI Services. | `list(string)` | `[]` | no |
| <a name="input_identity"></a> [identity](#input\_identity) | (Optional) The identity of the AI Services. | <pre>list(object({<br>    type         = string<br>    identity_ids = optional(list(string), null)<br>  }))</pre> | `[]` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | (Optional) The instance count for the Virtual Network. | `string` | `""` | no |
| <a name="input_local_authentication_enabled"></a> [local\_authentication\_enabled](#input\_local\_authentication\_enabled) | (Optional) Is local authentication enabled for the AI Services? | `bool` | `true` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location/region where the Virtual Network is created. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_module_tags"></a> [module\_tags](#input\_module\_tags) | (Optional) Include the default tags? | `bool` | `true` | no |
| <a name="input_network_acls"></a> [network\_acls](#input\_network\_acls) | (Optional) The network ACLs of the AI Services. | <pre>list(object({<br>    default_action = string<br>    ip_rules       = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "default_action": "Deny",<br>    "ip_rules": []<br>  }<br>]</pre> | no |
| <a name="input_outbound_network_access_restricted"></a> [outbound\_network\_access\_restricted](#input\_outbound\_network\_access\_restricted) | (Optional) Is outbound network access restricted for the AI Services? | `bool` | `false` | no |
| <a name="input_public_network_access"></a> [public\_network\_access](#input\_public\_network\_access) | (Optional) Is public network access enabled for the AI Services? | `string` | `"Disabled"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the Virtual Network. | `string` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | (Optional) The SKU of the AI Services. | `string` | `"S0"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `null` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | (Optional) The usage or application of the Virtual Network. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_custom_subdomain_name"></a> [custom\_subdomain\_name](#output\_custom\_subdomain\_name) | The custom subdomain name of the AI Services. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the AI Services. |
| <a name="output_identity"></a> [identity](#output\_identity) | The identity of the AI Services. |
| <a name="output_name"></a> [name](#output\_name) | The name of the AI Services. |
| <a name="output_primary_access_key"></a> [primary\_access\_key](#output\_primary\_access\_key) | The primary access key of the AI Services. |
<!-- END_TF_DOCS -->