## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_linux_virtual_machine"></a> [linux\_virtual\_machine](#module\_linux\_virtual\_machine) | ../linux_virtual_machine | n/a |
| <a name="module_locations"></a> [locations](#module\_locations) | azurerm/locations/azure | n/a |
| <a name="module_naming"></a> [naming](#module\_naming) | azurerm/naming/azure | n/a |
| <a name="module_rg"></a> [rg](#module\_rg) | ../resource_group | n/a |
| <a name="module_subnet"></a> [subnet](#module\_subnet) | ../subnet | n/a |
| <a name="module_vnet"></a> [vnet](#module\_vnet) | ../virtual_network | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | (Required) The address space that is used the Virtual Network. | `list(string)` | n/a | yes |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | (Optional) The DNS servers to be used with the Virtual Network. | `list(string)` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | (Required) The environment of the Virtual Network. | `string` | n/a | yes |
| <a name="input_instance"></a> [instance](#input\_instance) | (Optional) The instance count for the Virtual Network. | `string` | `"001"` | no |
| <a name="input_linux_virtual_machine"></a> [linux\_virtual\_machine](#input\_linux\_virtual\_machine) | (Optional) Include one Linux VM created per subnet. | `bool` | `true` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location/region where the Virtual Network is created. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_module_tags"></a> [module\_tags](#input\_module\_tags) | (Optional) Include the default tags? | `bool` | `true` | no |
| <a name="input_subnet_count"></a> [subnet\_count](#input\_subnet\_count) | (Optional) The number of subnets to be created within the Virtual Network. | `number` | `1` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `null` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | (Required) The usage or application of the Virtual Network. | `string` | n/a | yes |

## Outputs

No outputs.
