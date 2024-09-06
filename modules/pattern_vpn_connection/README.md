<!-- BEGIN_TF_DOCS -->
# Local Network Gateway
[![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurerm/resources/azure/latest/submodules/local_network_gateway)

Terraform module to create and manage a local network gateway.

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

module "local_network_gateway" {
  source              = "azurerm/resources/azure//modules/local_network_gateway"
  resource_group_name = module.resource_group.name
  location            = "westeurope"
  environment         = "dev"
  workload            = "example"
  instance            = "001"
  gateway_address     = "1.2.3.4"
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
| <a name="module_connection_1_to_2"></a> [connection\_1\_to\_2](#module\_connection\_1\_to\_2) | ../virtual_network_gateway_connection | n/a |
| <a name="module_connection_2_to_1"></a> [connection\_2\_to\_1](#module\_connection\_2\_to\_1) | ../virtual_network_gateway_connection | n/a |
| <a name="module_gateway_1"></a> [gateway\_1](#module\_gateway\_1) | ../local_network_gateway | n/a |
| <a name="module_gateway_2"></a> [gateway\_2](#module\_gateway\_2) | ../local_network_gateway | n/a |
| <a name="module_key_vault_secret"></a> [key\_vault\_secret](#module\_key\_vault\_secret) | ../key_vault_secret | n/a |

## Resources

| Name | Type |
|------|------|
| [random_password.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azurerm_public_ip.pip_gateway_1](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/public_ip) | data source |
| [azurerm_public_ip.pip_gateway_2](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/public_ip) | data source |
| [azurerm_virtual_network_gateway.gateway_1](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network_gateway) | data source |
| [azurerm_virtual_network_gateway.gateway_2](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network_gateway) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_name"></a> [custom\_name](#input\_custom\_name) | (Optional) The name of the Virtual Network. | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | (Optional) The environment of the Virtual Network. | `string` | `""` | no |
| <a name="input_gateway_1_id"></a> [gateway\_1\_id](#input\_gateway\_1\_id) | (Required) The ID of the virtual network gateway 1. | `string` | n/a | yes |
| <a name="input_gateway_2_id"></a> [gateway\_2\_id](#input\_gateway\_2\_id) | (Required) The ID of the virtual network gateway 2. | `string` | n/a | yes |
| <a name="input_instance"></a> [instance](#input\_instance) | (Optional) The instance count for the Virtual Network. | `string` | `""` | no |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | (Optional) The ID of the Key Vault. | `string` | `""` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location/region where the Virtual Network is created. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_module_tags"></a> [module\_tags](#input\_module\_tags) | (Optional) Include the default tags? | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `null` | no |
| <a name="input_vault_psk"></a> [vault\_psk](#input\_vault\_psk) | (Optional) Store the PSK in a Key Vault? | `bool` | `false` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | (Optional) The usage or application of the Virtual Network. | `string` | `""` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->