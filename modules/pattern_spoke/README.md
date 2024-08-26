<!-- BEGIN_TF_DOCS -->
# Spoke
[![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurerm/resources/azure/latest/submodules/pattern_spoke)

Terraform module to create and manage a Spoke.

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

module "spoke" {
  source        = "azurerm/resources/azure//modules/pattern_spoke"
  location      = "westeurope"
  environment   = "dev"
  workload      = "example"
  address_space = ["10.0.1.0/24"]
  subnet_count  = 2
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
| <a name="module_linux_virtual_machine"></a> [linux\_virtual\_machine](#module\_linux\_virtual\_machine) | ../linux_virtual_machine | n/a |
| <a name="module_maintenance_configuration"></a> [maintenance\_configuration](#module\_maintenance\_configuration) | ../maintenance_configuration | n/a |
| <a name="module_network_security_group"></a> [network\_security\_group](#module\_network\_security\_group) | ../network_security_group | n/a |
| <a name="module_network_security_rules"></a> [network\_security\_rules](#module\_network\_security\_rules) | ../network_security_rule | n/a |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | ../resource_group | n/a |
| <a name="module_routing"></a> [routing](#module\_routing) | ../pattern_routing | n/a |
| <a name="module_subnet"></a> [subnet](#module\_subnet) | ../subnet | n/a |
| <a name="module_subnet_network_security_group_association"></a> [subnet\_network\_security\_group\_association](#module\_subnet\_network\_security\_group\_association) | ../subnet_network_security_group_association | n/a |
| <a name="module_subnet_single_route_table_association"></a> [subnet\_single\_route\_table\_association](#module\_subnet\_single\_route\_table\_association) | ../subnet_route_table_association | n/a |
| <a name="module_virtual_network"></a> [virtual\_network](#module\_virtual\_network) | ../virtual_network | n/a |
| <a name="module_windows_virtual_machine"></a> [windows\_virtual\_machine](#module\_windows\_virtual\_machine) | ../windows_virtual_machine | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_maintenance_assignment_virtual_machine.linux_virtual_machine](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/maintenance_assignment_virtual_machine) | resource |
| [azurerm_maintenance_assignment_virtual_machine.windows_virtual_machine](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/maintenance_assignment_virtual_machine) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | (Required) The address space that is used the Virtual Network. | `list(string)` | n/a | yes |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | (Optional) The DNS servers to be used with the Virtual Network. | `list(string)` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | (Required) The environment of the Virtual Network. | `string` | n/a | yes |
| <a name="input_firewall"></a> [firewall](#input\_firewall) | (Optional) Firewall in Hub?. | `bool` | `false` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | (Optional) The instance count for the Virtual Network. | `string` | `"001"` | no |
| <a name="input_linux_virtual_machine"></a> [linux\_virtual\_machine](#input\_linux\_virtual\_machine) | (Optional) Include one Linux VM created per subnet. | `bool` | `true` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location/region where the Virtual Network is created. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_module_tags"></a> [module\_tags](#input\_module\_tags) | (Optional) Include the default tags? | `bool` | `true` | no |
| <a name="input_monitor_agent"></a> [monitor\_agent](#input\_monitor\_agent) | (Optional) Include monitoring. | `bool` | `false` | no |
| <a name="input_network_security_group"></a> [network\_security\_group](#input\_network\_security\_group) | (Optional) Include a Network Security Group. | `bool` | `false` | no |
| <a name="input_network_security_rules"></a> [network\_security\_rules](#input\_network\_security\_rules) | (Optional) A list of Network Security Rules. | <pre>list(object({<br>    name                       = string<br>    priority                   = number<br>    direction                  = string<br>    access                     = string<br>    protocol                   = string<br>    source_port_range          = string<br>    destination_port_range     = string<br>    source_address_prefix      = string<br>    destination_address_prefix = string<br>  }))</pre> | <pre>[<br>  {<br>    "access": "Allow",<br>    "destination_address_prefix": "10.0.0.0/8",<br>    "destination_port_range": "*",<br>    "direction": "Inbound",<br>    "name": "A-IN-Net10-Net10",<br>    "priority": 1000,<br>    "protocol": "*",<br>    "source_address_prefix": "10.0.0.0/8",<br>    "source_port_range": "*"<br>  },<br>  {<br>    "access": "Allow",<br>    "destination_address_prefix": "*",<br>    "destination_port_range": "*",<br>    "direction": "Inbound",<br>    "name": "A-IN-AzureLoadBalancer-Any",<br>    "priority": 4095,<br>    "protocol": "*",<br>    "source_address_prefix": "AzureLoadBalancer",<br>    "source_port_range": "*"<br>  },<br>  {<br>    "access": "Deny",<br>    "destination_address_prefix": "*",<br>    "destination_port_range": "*",<br>    "direction": "Inbound",<br>    "name": "D-IN-Any-Any",<br>    "priority": 4096,<br>    "protocol": "*",<br>    "source_address_prefix": "*",<br>    "source_port_range": "*"<br>  },<br>  {<br>    "access": "Allow",<br>    "destination_address_prefix": "10.0.0.0/8",<br>    "destination_port_range": "*",<br>    "direction": "Outbound",<br>    "name": "A-OUT-Net10-Net10",<br>    "priority": 1000,<br>    "protocol": "*",<br>    "source_address_prefix": "10.0.0.0/8",<br>    "source_port_range": "*"<br>  },<br>  {<br>    "access": "Allow",<br>    "destination_address_prefix": "Internet",<br>    "destination_port_range": "80",<br>    "direction": "Outbound",<br>    "name": "A-OUT-Net10-Internet-TCP-80",<br>    "priority": 1005,<br>    "protocol": "Tcp",<br>    "source_address_prefix": "10.0.0.0/8",<br>    "source_port_range": "*"<br>  },<br>  {<br>    "access": "Allow",<br>    "destination_address_prefix": "Internet",<br>    "destination_port_range": "443",<br>    "direction": "Outbound",<br>    "name": "A-OUT-Net10-Internet-TCP-443",<br>    "priority": 1010,<br>    "protocol": "Tcp",<br>    "source_address_prefix": "10.0.0.0/8",<br>    "source_port_range": "*"<br>  },<br>  {<br>    "access": "Allow",<br>    "destination_address_prefix": "20.118.99.224",<br>    "destination_port_range": "1688",<br>    "direction": "Outbound",<br>    "name": "A-OUT-Net10-AzureKMS1-TCP-1688",<br>    "priority": 1015,<br>    "protocol": "Tcp",<br>    "source_address_prefix": "10.0.0.0/8",<br>    "source_port_range": "*"<br>  },<br>  {<br>    "access": "Allow",<br>    "destination_address_prefix": "40.83.235.53",<br>    "destination_port_range": "1688",<br>    "direction": "Outbound",<br>    "name": "A-OUT-Net10-AzureKMS2-TCP-1688",<br>    "priority": 1020,<br>    "protocol": "Tcp",<br>    "source_address_prefix": "10.0.0.0/8",<br>    "source_port_range": "*"<br>  },<br>  {<br>    "access": "Allow",<br>    "destination_address_prefix": "51.145.123.29",<br>    "destination_port_range": "123",<br>    "direction": "Outbound",<br>    "name": "A-OUT-Net10-AzureNTP1-UDP-123",<br>    "priority": 1025,<br>    "protocol": "Udp",<br>    "source_address_prefix": "10.0.0.0/8",<br>    "source_port_range": "*"<br>  },<br>  {<br>    "access": "Allow",<br>    "destination_address_prefix": "51.137.137.111",<br>    "destination_port_range": "123",<br>    "direction": "Outbound",<br>    "name": "A-OUT-Net10-AzureNTP2-UDP-123",<br>    "priority": 1030,<br>    "protocol": "Udp",<br>    "source_address_prefix": "10.0.0.0/8",<br>    "source_port_range": "*"<br>  },<br>  {<br>    "access": "Deny",<br>    "destination_address_prefix": "*",<br>    "destination_port_range": "*",<br>    "direction": "Outbound",<br>    "name": "D-OUT-Any-Any",<br>    "priority": 4096,<br>    "protocol": "*",<br>    "source_address_prefix": "*",<br>    "source_port_range": "*"<br>  }<br>]</pre> | no |
| <a name="input_next_hop"></a> [next\_hop](#input\_next\_hop) | (Optional) The default next hop of the Virtual Network. | `string` | `""` | no |
| <a name="input_route_table_id"></a> [route\_table\_id](#input\_route\_table\_id) | (Optianal) The Route Table ID only used if single\_route\_table is set to true. | `string` | `""` | no |
| <a name="input_single_route_table"></a> [single\_route\_table](#input\_single\_route\_table) | (Optional) Use a single Route Table for all the Applications Spokes. | `bool` | `false` | no |
| <a name="input_subnet_count"></a> [subnet\_count](#input\_subnet\_count) | (Optional) The number of subnets to be created within the Virtual Network. | `number` | `1` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `null` | no |
| <a name="input_update_management"></a> [update\_management](#input\_update\_management) | (Optional) Include update management. | `bool` | `false` | no |
| <a name="input_virtual_machine_size"></a> [virtual\_machine\_size](#input\_virtual\_machine\_size) | (Optional) The size of the Virtual Machine. | `string` | `"Standard_B1ls"` | no |
| <a name="input_watcher_agent"></a> [watcher\_agent](#input\_watcher\_agent) | (Optional) Include watcher. | `bool` | `false` | no |
| <a name="input_windows_virtual_machine"></a> [windows\_virtual\_machine](#input\_windows\_virtual\_machine) | (Optional) Include one Windows VM created per subnet. | `bool` | `true` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | (Required) The usage or application of the Virtual Network. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_address_space"></a> [address\_space](#output\_address\_space) | The address space of the virtual network. |
| <a name="output_linux_virtual_machine_admin_password"></a> [linux\_virtual\_machine\_admin\_password](#output\_linux\_virtual\_machine\_admin\_password) | The password of the Linux Virtual Machine. |
| <a name="output_linux_virtual_machine_admin_username"></a> [linux\_virtual\_machine\_admin\_username](#output\_linux\_virtual\_machine\_admin\_username) | The password of the Linux Virtual Machine. |
| <a name="output_linux_virtual_machine_name"></a> [linux\_virtual\_machine\_name](#output\_linux\_virtual\_machine\_name) | The name of the Linux Virtual Machine. |
| <a name="output_network_security_group_id"></a> [network\_security\_group\_id](#output\_network\_security\_group\_id) | The ID of the Network Security Group. |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of the resource group of the spoke. |
| <a name="output_virtual_machines"></a> [virtual\_machines](#output\_virtual\_machines) | The virtual machines. |
| <a name="output_virtual_network_id"></a> [virtual\_network\_id](#output\_virtual\_network\_id) | The ID of the virtual network of the spoke. |
| <a name="output_virtual_network_name"></a> [virtual\_network\_name](#output\_virtual\_network\_name) | The name of the virtual network of the spoke. |
| <a name="output_windows_virtual_machine_admin_password"></a> [windows\_virtual\_machine\_admin\_password](#output\_windows\_virtual\_machine\_admin\_password) | The password of the Windows Virtual Machine. |
| <a name="output_windows_virtual_machine_admin_username"></a> [windows\_virtual\_machine\_admin\_username](#output\_windows\_virtual\_machine\_admin\_username) | The password of the Windows Virtual Machine. |
| <a name="output_windows_virtual_machine_name"></a> [windows\_virtual\_machine\_name](#output\_windows\_virtual\_machine\_name) | The name of the Windows Virtual Machine. |
<!-- END_TF_DOCS -->