<!-- BEGIN_TF_DOCS -->
# Firewall
[![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurerm/resources/azure/latest/submodules/web_application_firewall_policy)

Terraform module to create and manage a WAF Policy.

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
| [azurerm_web_application_firewall_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/web_application_firewall_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_name"></a> [custom\_name](#input\_custom\_name) | (Optional) The name of the Virtual Network. | `string` | `""` | no |
| <a name="input_custom_rules_configuration"></a> [custom\_rules\_configuration](#input\_custom\_rules\_configuration) | n/a | <pre>list(object({<br>    name      = string<br>    priority  = number<br>    rule_type = string<br>    action    = string<br>    match_conditions_configuration = list(object({<br>      match_variable_configuration = list(object({<br>        match_variable = string<br>        selector       = string<br>      }))<br>      match_values       = list(string)<br>      operator           = string<br>      negation_condition = string<br>      transforms         = list(string)<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | (Optional) The environment of the Virtual Network. | `string` | `""` | no |
| <a name="input_exclusion_configuration"></a> [exclusion\_configuration](#input\_exclusion\_configuration) | n/a | <pre>list(object({<br>    match_variable          = string<br>    selector                = string<br>    selector_match_operator = string<br>    excluded_rule_set_configuration = list(object({<br>      type    = string<br>      version = string<br>      rule_group_configuration = list(object({<br>        rule_group_name = string<br>        excluded_rules  = list(string)<br>      }))<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | (Optional) The instance count for the Virtual Network. | `string` | `""` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location/region where the Virtual Network is created. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_managed_rule_set_type"></a> [managed\_rule\_set\_type](#input\_managed\_rule\_set\_type) | n/a | `string` | `"OWASP"` | no |
| <a name="input_managed_rule_set_version"></a> [managed\_rule\_set\_version](#input\_managed\_rule\_set\_version) | n/a | `string` | `"3.2"` | no |
| <a name="input_module_tags"></a> [module\_tags](#input\_module\_tags) | (Optional) Include the default tags? | `bool` | `true` | no |
| <a name="input_policy_settings_enabled"></a> [policy\_settings\_enabled](#input\_policy\_settings\_enabled) | (Optional) Is the Application Gateway enabled?. | `bool` | `true` | no |
| <a name="input_policy_settings_file_upload_limit_in_mb"></a> [policy\_settings\_file\_upload\_limit\_in\_mb](#input\_policy\_settings\_file\_upload\_limit\_in\_mb) | (Optional) The maximum file upload size in MB. | `number` | `100` | no |
| <a name="input_policy_settings_max_request_body_size_in_kb"></a> [policy\_settings\_max\_request\_body\_size\_in\_kb](#input\_policy\_settings\_max\_request\_body\_size\_in\_kb) | (Optional) The maximum request body size in KB. | `number` | `128` | no |
| <a name="input_policy_settings_mode"></a> [policy\_settings\_mode](#input\_policy\_settings\_mode) | (Optional) The operating mode for the Application Gateway. Possible values are WAF or Detection. Defaults to Detection. | `string` | `"Detection"` | no |
| <a name="input_policy_settings_request_body_check"></a> [policy\_settings\_request\_body\_check](#input\_policy\_settings\_request\_body\_check) | (Optional) Should the Application Gateway inspect the request body?. | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the Virtual Network. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `null` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | (Optional) The usage or application of the Virtual Network. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the WAF Policy. |
<!-- END_TF_DOCS -->