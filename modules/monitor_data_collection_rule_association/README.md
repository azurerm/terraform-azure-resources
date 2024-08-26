<!-- BEGIN_TF_DOCS -->
# Monitor Data Collection Rule Association
[![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurerm/resources/azure/latest/submodules/monitor_data_collection_rule_association)

Terraform module to create and manage a Monitor Data Collection Rule Association.

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

module "data_collection_endpoint_association" {
  source                      = "azurerm/resources/azure//modules/monitor_data_collection_rule_association"
  target_resource_id          = var.target_resource_id
  data_collection_endpoint_id = var.data_collection_endpoint_id
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_monitor_data_collection_rule_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_rule_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_data_collection_endpoint_id"></a> [data\_collection\_endpoint\_id](#input\_data\_collection\_endpoint\_id) | (Optional) The ID of the Data Collection Endpoint. | `string` | `null` | no |
| <a name="input_data_collection_rule_id"></a> [data\_collection\_rule\_id](#input\_data\_collection\_rule\_id) | (Optional) The ID of the Data Collection Rule. | `string` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | (Optional) The description of the Data Collection Rule Association. | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | (Optional) The name of the Data Collection Rule Association. | `string` | `null` | no |
| <a name="input_target_resource_id"></a> [target\_resource\_id](#input\_target\_resource\_id) | (Required) The ID of the resource to monitore. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the monitor data collection rule association. |
<!-- END_TF_DOCS -->