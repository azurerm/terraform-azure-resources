<!-- BEGIN_TF_DOCS -->
# Network Security Rule
[![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurerm/resources/azure/latest/submodules/network_security_rule)

Terraform module to create and manage a Network Security Rule.

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

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_network_security_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access"></a> [access](#input\_access) | (Optional) The Access of the network security rule. Possible values are Allow and Deny. | `string` | `"Allow"` | no |
| <a name="input_destination_address_prefix"></a> [destination\_address\_prefix](#input\_destination\_address\_prefix) | (Optional) The destination address prefix. CIDR or * to match any IP address. | `string` | `"*"` | no |
| <a name="input_destination_port_range"></a> [destination\_port\_range](#input\_destination\_port\_range) | (Optional) The destination port or range. Integer or range between 0 and 65535. Asterisk (*) can also be used to match all ports. | `string` | `"*"` | no |
| <a name="input_direction"></a> [direction](#input\_direction) | (Required) The direction of the network security rule. Possible values are Inbound and Outbound. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the network security rule. | `string` | n/a | yes |
| <a name="input_network_security_group_name"></a> [network\_security\_group\_name](#input\_network\_security\_group\_name) | (Required) The name of the network security group to which to attach the rule. | `string` | n/a | yes |
| <a name="input_priority"></a> [priority](#input\_priority) | (Required) The priority of the network security rule. | `number` | n/a | yes |
| <a name="input_protocol"></a> [protocol](#input\_protocol) | (Optional) The network protocol this rule applies to. Possible values are Tcp, Udp, Icmp, Esp, * (which matches all protocols). | `string` | `"TCP"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the Virtual Network. | `string` | n/a | yes |
| <a name="input_source_address_prefix"></a> [source\_address\_prefix](#input\_source\_address\_prefix) | (Optional) The source address prefix. CIDR or * to match any IP address. | `string` | `"*"` | no |
| <a name="input_source_port_range"></a> [source\_port\_range](#input\_source\_port\_range) | (Optional) The source port or range. Integer or range between 0 and 65535. Asterisk (*) can also be used to match all ports. | `string` | `"*"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->