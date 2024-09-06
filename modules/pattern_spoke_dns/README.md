<!-- BEGIN_TF_DOCS -->
# Spoke with DNS Forwarder
[![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurerm/resources/azure/latest/submodules/pattern_spoke_dns)

Terraform module to create and manage a Spoke with DNS Forwarder.

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

module "spoke_dns" {
  source        = "azurerm/resources/azure//modules/pattern_spoke_dns"
  location      = "westeurope"
  address_space = ["10.0.3.0/24"]
  dns_forwarding_rules = [
    {
      domain_name = "example.com."
      target_dns_servers = [
        {
          ip_address = "192.168.10.5"
          port       = 53
        }
      ]
    },
    {
      domain_name = "example2.com."
      target_dns_servers = [
        {
          ip_address = "192.168.10.5"
          port       = 53
        }
      ]
    }
  ]
}
```

## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_private_dns_resolver"></a> [private\_dns\_resolver](#module\_private\_dns\_resolver) | ../private_dns_resolver | n/a |
| <a name="module_private_dns_resolver_dns_forwarding_ruleset"></a> [private\_dns\_resolver\_dns\_forwarding\_ruleset](#module\_private\_dns\_resolver\_dns\_forwarding\_ruleset) | ../private_dns_resolver_dns_forwarding_ruleset | n/a |
| <a name="module_private_dns_resolver_forwarding_rules"></a> [private\_dns\_resolver\_forwarding\_rules](#module\_private\_dns\_resolver\_forwarding\_rules) | ../private_dns_resolver_forwarding_rule | n/a |
| <a name="module_private_dns_zones"></a> [private\_dns\_zones](#module\_private\_dns\_zones) | ../private_dns_zone | n/a |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | ../resource_group | n/a |
| <a name="module_routing_inbound"></a> [routing\_inbound](#module\_routing\_inbound) | ../pattern_routing | n/a |
| <a name="module_routing_outbound"></a> [routing\_outbound](#module\_routing\_outbound) | ../pattern_routing | n/a |
| <a name="module_subnet_inbound"></a> [subnet\_inbound](#module\_subnet\_inbound) | ../subnet | n/a |
| <a name="module_subnet_outbound"></a> [subnet\_outbound](#module\_subnet\_outbound) | ../subnet | n/a |
| <a name="module_virtual_network"></a> [virtual\_network](#module\_virtual\_network) | ../virtual_network | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | (Required) The address space that is used the Virtual Network. | `list(string)` | n/a | yes |
| <a name="input_default_next_hop"></a> [default\_next\_hop](#input\_default\_next\_hop) | (Optional) The default next hop of the Virtual Network. | `string` | `""` | no |
| <a name="input_dns_forwarding_rules"></a> [dns\_forwarding\_rules](#input\_dns\_forwarding\_rules) | (Optional) A list of DNS forwarding rules. | <pre>list(object({<br>    domain_name = string<br>    target_dns_servers = list(object({<br>      ip_address = string<br>      port       = number<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | (Optional) The environment of the Virtual Network. | `string` | `"prd"` | no |
| <a name="input_firewall"></a> [firewall](#input\_firewall) | (Optional) Firewall in Hub?. | `bool` | `false` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | (Optional) The instance count for the Virtual Network. | `string` | `"001"` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location/region where the Virtual Network is created. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_module_tags"></a> [module\_tags](#input\_module\_tags) | (Optional) Include the default tags? | `bool` | `true` | no |
| <a name="input_private_endpoint_zones"></a> [private\_endpoint\_zones](#input\_private\_endpoint\_zones) | (Optional) A list of private endpoint zones. | `list(string)` | <pre>[<br>  "privatelink.blob.core.windows.net",<br>  "privatelink.agentsvc.azure-automation.net",<br>  "privatelink.monitor.azure.com",<br>  "privatelink.ods.opinsights.azure.com",<br>  "privatelink.oms.opinsights.azure.com",<br>  "privatelink.vaultcore.azure.net",<br>  "privatelink.cognitiveservices.azure.com",<br>  "privatelink.openai.azure.com",<br>  "privatelink.azurewebsites.net",<br>  "privatelink.search.windows.net"<br>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `null` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | (Optional) The usage or application of the Virtual Network. | `string` | `"dns"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_address_space"></a> [address\_space](#output\_address\_space) | The address space of the virtual network. |
| <a name="output_inbound_endpoint_ip"></a> [inbound\_endpoint\_ip](#output\_inbound\_endpoint\_ip) | The IP address of the Private DNS Resolver Inbound Endpoint. |
| <a name="output_private_dns_zones"></a> [private\_dns\_zones](#output\_private\_dns\_zones) | The IDs of the private DNS zones. |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of the resource group of the spoke. |
| <a name="output_virtual_network_id"></a> [virtual\_network\_id](#output\_virtual\_network\_id) | The ID of the spoke. |
| <a name="output_virtual_network_name"></a> [virtual\_network\_name](#output\_virtual\_network\_name) | The name of the virtual network of the spoke. |
<!-- END_TF_DOCS -->