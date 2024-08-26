<!-- BEGIN_TF_DOCS -->
# Public IP
[![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurerm/resources/azure/latest/submodules/application_gateway)

Terraform module to create and manage an Azure Application Gateway.

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

module "public_ip" {
  source              = "azurerm/resources/azure//modules/public_ip"
  resource_group_name = module.resource_group.name
  location            = "westeurope"
  environment         = "dev"
  workload            = "bast"
  instance            = "001"
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
| [azurerm_application_gateway.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backend_address_pools"></a> [backend\_address\_pools](#input\_backend\_address\_pools) | (Optional) A list of Backend Address Pools which should be used for the Application Gateway. | <pre>list(object({<br>    name         = string<br>    ip_addresses = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "ip_addresses": [],<br>    "name": "BackendPool"<br>  }<br>]</pre> | no |
| <a name="input_backend_http_settings"></a> [backend\_http\_settings](#input\_backend\_http\_settings) | (Optional) A list of Backend HTTP Settings which should be used for the Application Gateway. | <pre>list(object({<br>    name                  = string<br>    cookie_based_affinity = string<br>    path                  = string<br>    port                  = number<br>    protocol              = string<br>    request_timeout       = number<br>  }))</pre> | <pre>[<br>  {<br>    "cookie_based_affinity": "Disabled",<br>    "name": "BackendHttpSettings",<br>    "path": "/",<br>    "port": 80,<br>    "protocol": "Http",<br>    "request_timeout": 30<br>  }<br>]</pre> | no |
| <a name="input_custom_name"></a> [custom\_name](#input\_custom\_name) | (Optional) The name of the Virtual Network. | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | (Optional) The environment of the Virtual Network. | `string` | `""` | no |
| <a name="input_firewall_policy_id"></a> [firewall\_policy\_id](#input\_firewall\_policy\_id) | (Optional) The ID of the Firewall Policy to associate with this Firewall. | `string` | `null` | no |
| <a name="input_frontend_ip_configuration_name"></a> [frontend\_ip\_configuration\_name](#input\_frontend\_ip\_configuration\_name) | (Optional) The name of the Frontend IP Configuration. | `string` | `"FrontendIPConfig"` | no |
| <a name="input_frontend_ports"></a> [frontend\_ports](#input\_frontend\_ports) | (Optional) A list of Frontend Ports which should be used for the Application Gateway. | <pre>list(object({<br>    name = string<br>    port = number<br>  }))</pre> | <pre>[<br>  {<br>    "name": "FrontendPort80",<br>    "port": 80<br>  }<br>]</pre> | no |
| <a name="input_http_listeners"></a> [http\_listeners](#input\_http\_listeners) | (Optional) A list of HTTP Listeners which should be used for the Application Gateway. | <pre>list(object({<br>    name                           = string<br>    frontend_ip_configuration_name = string<br>    frontend_port_name             = string<br>    protocol                       = string<br>    host_name                      = string<br>  }))</pre> | <pre>[<br>  {<br>    "frontend_ip_configuration_name": "FrontendIPConfig",<br>    "frontend_port_name": "FrontendPort80",<br>    "host_name": "",<br>    "name": "HttpListener",<br>    "protocol": "Http"<br>  }<br>]</pre> | no |
| <a name="input_instance"></a> [instance](#input\_instance) | (Optional) The instance count for the Virtual Network. | `string` | `""` | no |
| <a name="input_ip_configuration_name"></a> [ip\_configuration\_name](#input\_ip\_configuration\_name) | (Optional) The name of the IP Configuration. | `string` | `"ipconfig"` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location/region where the Virtual Network is created. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_max_capacity"></a> [max\_capacity](#input\_max\_capacity) | (Optional) The maximum number of instances to use when autoscaling. | `number` | `3` | no |
| <a name="input_min_capacity"></a> [min\_capacity](#input\_min\_capacity) | (Optional) The minimum number of instances to use when autoscaling. | `number` | `1` | no |
| <a name="input_module_tags"></a> [module\_tags](#input\_module\_tags) | (Optional) Include the default tags? | `bool` | `true` | no |
| <a name="input_public_ip_address_id"></a> [public\_ip\_address\_id](#input\_public\_ip\_address\_id) | (Required) The ID of the Public IP Address to which the Bastion Host should be attached. | `string` | n/a | yes |
| <a name="input_request_routing_rules"></a> [request\_routing\_rules](#input\_request\_routing\_rules) | (Optional) A list of Request Routing Rules which should be used for the Application Gateway. | <pre>list(object({<br>    name                       = string<br>    rule_type                  = string<br>    http_listener_name         = string<br>    backend_address_pool_name  = string<br>    backend_http_settings_name = string<br>    priority                   = number<br>  }))</pre> | <pre>[<br>  {<br>    "backend_address_pool_name": "BackendPool",<br>    "backend_http_settings_name": "BackendHttpSettings",<br>    "http_listener_name": "HttpListener",<br>    "name": "RequestRoutingRule",<br>    "priority": 100,<br>    "rule_type": "Basic"<br>  }<br>]</pre> | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the Virtual Network. | `string` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | (Optional) The SKU of the Application Gateway. | `string` | `"Standard_v2"` | no |
| <a name="input_sku_tier"></a> [sku\_tier](#input\_sku\_tier) | (Optional) The Tier of the Application Gateway. | `string` | `"Standard_v2"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | (Required) The ID of the Subnet to which the Bastion Host should be attached. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `null` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | (Optional) The usage or application of the Virtual Network. | `string` | `""` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | (Optional) A list of Availability Zones which should be used for the Application Gateway. | `list(string)` | <pre>[<br>  "1",<br>  "2",<br>  "3"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the application gateway. |
| <a name="output_name"></a> [name](#output\_name) | The name of the application gateway. |
<!-- END_TF_DOCS -->