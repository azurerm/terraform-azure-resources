<!-- BEGIN_TF_DOCS -->
# Virtual Network Gateway
[![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurerm/resources/azure/latest/submodules/virtual_network_gateway)

Terraform module to create and manage a Virtual Network Gateway.

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

module "virtual_network" {
  source              = "azurerm/resources/azure//modules/virtual_network"
  location            = "westeurope"
  environment         = "prd"
  workload            = "hub"
  instance            = "001"
  resource_group_name = module.resource_group.name
  address_space       = ["10.0.0.0/24"]
}

module "subnet" {
  source               = "azurerm/resources/azure//modules/subnet"
  location             = "westeurope"
  custom_name          = "GatewaySubnet"
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.virtual_network.name
  address_prefixes     = ["10.0.0.0/25"]
}

module "publicip" {
  source              = "azurerm/resources/azure//modules/public_ip"
  location            = "westeurope"
  environment         = "prd"
  workload            = "gateway"
  instance            = "001"
  resource_group_name = module.resource_group.name
}

module "gateway" {
  source               = "./modules/virtual_network_gateway"
  location             = "westeurope"
  environment          = "prd"
  workload             = "hub"
  instance             = "001"
  resource_group_name  = module.resource_group.name
  public_ip_address_id = module.publicip.id
  subnet_id            = module.subnet.id
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
| [azurerm_virtual_network_gateway.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway) | resource |
| [random_integer.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_active_active"></a> [active\_active](#input\_active\_active) | (Optional) Is Active Active? | `bool` | `false` | no |
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | (Optional) The address space that is used the Hub. | `list(string)` | <pre>[<br>  "10.99.255.0/24"<br>]</pre> | no |
| <a name="input_asn"></a> [asn](#input\_asn) | (Optional) The BGP speaker's ASN. Default is set to 65000 to avoid conflit with Azure default ASN. If set to 0, random ASN is generated | `number` | `65000` | no |
| <a name="input_custom_name"></a> [custom\_name](#input\_custom\_name) | (Optional) The name of the Virtual Network. | `string` | `""` | no |
| <a name="input_enable_bgp"></a> [enable\_bgp](#input\_enable\_bgp) | (Optional) Is BGP Enabled? | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | (Optional) The environment of the Virtual Network. | `string` | `""` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | (Optional) The instance count for the Virtual Network. | `string` | `""` | no |
| <a name="input_ip_configurations"></a> [ip\_configurations](#input\_ip\_configurations) | (Required) List of IP configuration of the Gateway | <pre>list(object({<br>    name                          = optional(string, "ipconfig")<br>    public_ip_address_id          = string<br>    private_ip_address_allocation = optional(string, "Dynamic")<br>    subnet_id                     = string<br>  }))</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location/region where the Virtual Network is created. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_module_tags"></a> [module\_tags](#input\_module\_tags) | (Optional) Include the default tags? | `bool` | `true` | no |
| <a name="input_p2s_vpn"></a> [p2s\_vpn](#input\_p2s\_vpn) | (Optional) Include a Point-to-Site VPN configuration. | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the Virtual Network. | `string` | n/a | yes |
| <a name="input_sku"></a> [sku](#input\_sku) | (Optional) The Sku name of the Virtual Network Gateway. | `string` | `"VpnGw1AZ"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `null` | no |
| <a name="input_type"></a> [type](#input\_type) | (Optional) The type of the Virtual Network Gateway : ExpressRoute or Vpn. | `string` | `"Vpn"` | no |
| <a name="input_vpn_type"></a> [vpn\_type](#input\_vpn\_type) | (Optional) The type of this Virtual Network Gateway : PolicyBased or RouteBased. | `string` | `"RouteBased"` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | (Optional) The usage or application of the Virtual Network. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Virtual Network Gateway. |
| <a name="output_name"></a> [name](#output\_name) | The name of the Virtual Network Gateway. |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of the resource group in which to create the Virtual Network Gateway. |
<!-- END_TF_DOCS -->