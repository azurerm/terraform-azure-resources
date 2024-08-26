<!-- BEGIN_TF_DOCS -->
# Spoke with DNS Forwarder
[![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurerm/resources/azure/latest/submodules/pattern_spoke_dns)

Terraform module to create and manage a Spoke with a Linux and Windows VM to use as jumphost.

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

module "spoke_jumphost" {
  source        = "azurerm/resources/azure//modules/pattern_spoke_jumphost"
  location      = "westeurope"
  address_space = ["10.0.3.0/24"]
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_http"></a> [http](#provider\_http) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_linux_virtual_machine"></a> [linux\_virtual\_machine](#module\_linux\_virtual\_machine) | ../linux_virtual_machine | n/a |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | ../resource_group | n/a |
| <a name="module_routing"></a> [routing](#module\_routing) | ../pattern_routing | n/a |
| <a name="module_subnet"></a> [subnet](#module\_subnet) | ../subnet | n/a |
| <a name="module_virtual_network"></a> [virtual\_network](#module\_virtual\_network) | ../virtual_network | n/a |
| <a name="module_windows_virtual_machine"></a> [windows\_virtual\_machine](#module\_windows\_virtual\_machine) | ../windows_virtual_machine | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_firewall_policy_rule_collection_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy_rule_collection_group) | resource |
| [http_http.ipinfo](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | (Required) The address space that is used the Virtual Network. | `list(string)` | n/a | yes |
| <a name="input_default_next_hop"></a> [default\_next\_hop](#input\_default\_next\_hop) | (Optional) The default next hop of the Virtual Network. | `string` | `""` | no |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | (Optional) The DNS servers to be used with the Virtual Network. | `list(string)` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | (Optional) The environment of the Virtual Network. | `string` | `"prd"` | no |
| <a name="input_firewall"></a> [firewall](#input\_firewall) | (Optional) Firewall in Hub?. | `bool` | `false` | no |
| <a name="input_firewall_policy_id"></a> [firewall\_policy\_id](#input\_firewall\_policy\_id) | (Optional) The ID of the Firewall Policy. | `string` | `""` | no |
| <a name="input_firewall_public_ip"></a> [firewall\_public\_ip](#input\_firewall\_public\_ip) | (Optional) The public IP address of the Firewall. | `string` | `""` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | (Optional) The instance count for the Virtual Network. | `string` | `"001"` | no |
| <a name="input_linux_virtual_machine"></a> [linux\_virtual\_machine](#input\_linux\_virtual\_machine) | (Optional) Include one Linux VM created per subnet. | `bool` | `true` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location/region where the Virtual Network is created. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_module_tags"></a> [module\_tags](#input\_module\_tags) | (Optional) Include the default tags? | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `null` | no |
| <a name="input_virtual_machine_size"></a> [virtual\_machine\_size](#input\_virtual\_machine\_size) | (Optional) The size of the Virtual Machine. | `string` | `"Standard_B1ls"` | no |
| <a name="input_windows_virtual_machine"></a> [windows\_virtual\_machine](#input\_windows\_virtual\_machine) | (Optional) Include one Windows VM created per subnet. | `bool` | `true` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | (Optional) The usage or application of the Virtual Network. | `string` | `"jump"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_address_space"></a> [address\_space](#output\_address\_space) | The address space of the virtual network. |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of the resource group of the spoke. |
| <a name="output_virtual_machines"></a> [virtual\_machines](#output\_virtual\_machines) | The virtual machines. |
| <a name="output_virtual_network_id"></a> [virtual\_network\_id](#output\_virtual\_network\_id) | The ID of the spoke. |
| <a name="output_virtual_network_name"></a> [virtual\_network\_name](#output\_virtual\_network\_name) | The name of the virtual network of the spoke. |
<!-- END_TF_DOCS -->