# Hub & Spoke
[![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurerm/resources/azure/latest/submodules/custom_hub_and_spoke)

Terraform module to create and manage an Hub & Spoke.

## Example

```hcl
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "custom_hub_and_spoke" {
  source            = "azurerm/resources/azure//modules/custom_hub_and_spoke"
  location          = "westeurope"
  address_space_hub = ["10.100.0.0/24"]
  address_space_spoke = [
    {
      workload      = "app1"
      environment   = "dev"
      instance      = "001"
      address_space = ["10.100.1.0/24"]
    },
    {
      workload      = "app2"
      environment   = "dev"
      instance      = "001"
      address_space = ["10.100.2.0/24"]
    },
    {
      workload      = "app1"
      environment   = "prd"
      instance      = "001"
      address_space = ["10.110.1.0/24"]
    },
    {
      workload      = "app2"
      environment   = "prd"
      instance      = "001"
      address_space = ["10.110.2.0/24"]
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
| <a name="module_hub"></a> [hub](#module\_hub) | azurerm/resources/azure//modules/custom_hub | n/a |
| <a name="module_locations"></a> [locations](#module\_locations) | azurerm/locations/azure | n/a |
| <a name="module_naming"></a> [naming](#module\_naming) | azurerm/naming/azure | n/a |
| <a name="module_spoke"></a> [spoke](#module\_spoke) | azurerm/resources/azure//modules/custom_spoke | n/a |
| <a name="module_virtual_network_peerings"></a> [virtual\_network\_peerings](#module\_virtual\_network\_peerings) | azurerm/resources/azure//modules/virtual_network_peerings | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_space_hub"></a> [address\_space\_hub](#input\_address\_space\_hub) | (Required) The address space that is used the Virtual Network. | `list(string)` | n/a | yes |
| <a name="input_address_space_spoke"></a> [address\_space\_spoke](#input\_address\_space\_spoke) | (Required) The address space that is used the Virtual Network. | <pre>list(object({<br>    workload      = string<br>    environment   = string<br>    instance      = string<br>    address_space = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | (Optional) The DNS servers to be used with the Virtual Network. | `list(string)` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | (Optional) The environment of the Virtual Network. | `string` | `"prd"` | no |
| <a name="input_firewall"></a> [firewall](#input\_firewall) | (Optional) Include a Firewall. | `bool` | `true` | no |
| <a name="input_gateway"></a> [gateway](#input\_gateway) | (Optional) Include a Gateway. | `bool` | `true` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | (Optional) The instance count for the Virtual Network. | `string` | `"001"` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location/region where the Virtual Network is created. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_module_tags"></a> [module\_tags](#input\_module\_tags) | (Optional) Include the default tags? | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `null` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | (Optional) The usage or application of the Virtual Network. | `string` | `"hub"` | no |

## Outputs

No outputs.
