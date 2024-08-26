<!-- BEGIN_TF_DOCS -->
# Firewall
[![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurerm/resources/azure/latest/submodules/firewall_policy)

Terraform module to create and manage a Firewall Policy.

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
  workload    = "hub"
  instance    = "001"
}

module "firewall_policy" {
  source              = "./modules/firewall_policy"
  location            = "westeurope"
  environment         = "prd"
  workload            = "hub"
  instance            = "001"
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
| [azurerm_firewall_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_learn_private_ranges_enabled"></a> [auto\_learn\_private\_ranges\_enabled](#input\_auto\_learn\_private\_ranges\_enabled) | (Optional) Is auto-learning of private IP address ranges enabled? | `bool` | `false` | no |
| <a name="input_base_policy_id"></a> [base\_policy\_id](#input\_base\_policy\_id) | (Optional) The ID of the base policy to use for this Firewall Policy. | `string` | `null` | no |
| <a name="input_custom_name"></a> [custom\_name](#input\_custom\_name) | (Optional) The name of the Virtual Network. | `string` | `""` | no |
| <a name="input_dns_proxy_enabled"></a> [dns\_proxy\_enabled](#input\_dns\_proxy\_enabled) | (Optional) Is DNS Proxy enabled? | `bool` | `false` | no |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | (Optional) The DNS servers to be used with the Virtual Network. | `list(string)` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | (Optional) The environment of the Virtual Network. | `string` | `""` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | (Optional) The instance count for the Virtual Network. | `string` | `""` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location/region where the Virtual Network is created. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_module_tags"></a> [module\_tags](#input\_module\_tags) | (Optional) Include the default tags? | `bool` | `true` | no |
| <a name="input_private_ip_ranges"></a> [private\_ip\_ranges](#input\_private\_ip\_ranges) | (Optional) A list of private IP address ranges to be used by the Firewall Policy. | `list(string)` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the Virtual Network. | `string` | n/a | yes |
| <a name="input_sku"></a> [sku](#input\_sku) | (Optional) The SKU of the Firewall Policy. | `string` | `"Standard"` | no |
| <a name="input_sql_redirect_allowed"></a> [sql\_redirect\_allowed](#input\_sql\_redirect\_allowed) | (Optional) Is SQL redirect allowed? | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `null` | no |
| <a name="input_threat_intelligence_mode"></a> [threat\_intelligence\_mode](#input\_threat\_intelligence\_mode) | (Optional) The Threat Intelligence mode of the Firewall Policy. | `string` | `"Alert"` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | (Optional) The usage or application of the Virtual Network. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Firewall Policy. |
| <a name="output_name"></a> [name](#output\_name) | The name of the Firewall. |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of the resource group in which to create the Firewall. |
<!-- END_TF_DOCS -->