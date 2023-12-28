variable "custom_name" {
  description = "(Optional) The name of the Virtual Network."
  type        = string
  default     = ""
}

variable "workload" {
  description = "(Optional) The usage or application of the Virtual Network."
  type        = string
  default     = ""
}

variable "environment" {
  description = "(Optional) The environment of the Virtual Network."
  type        = string
  default     = ""
}

variable "location" {
  description = "(Required) The location/region where the Virtual Network is created. Changing this forces a new resource to be created."
  type        = string
}

variable "instance" {
  description = "(Optional) The instance count for the Virtual Network."
  type        = string
  default     = ""
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Virtual Network."
  type        = string
}

variable "zones" {
  description = "(Optional) A list of Availability Zones which should be used for the Application Gateway."
  type        = list(string)
  default     = ["1", "2", "3"]
}

variable "firewall_policy_id" {
  description = "(Optional) The ID of the Firewall Policy to associate with this Firewall."
  type        = string
  default     = null
}

variable "sku_name" {
  description = "(Optional) The SKU of the Application Gateway."
  type        = string
  default     = "Standard_v2"
}

variable "sku_tier" {
  description = "(Optional) The Tier of the Application Gateway."
  type        = string
  default     = "Standard_v2"

}

variable "min_capacity" {
  description = "(Optional) The minimum number of instances to use when autoscaling."
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "(Optional) The maximum number of instances to use when autoscaling."
  type        = number
  default     = 3
}

variable "ip_configuration_name" {
  description = "(Optional) The name of the IP Configuration."
  type        = string
  default     = "ipconfig"
}

variable "subnet_id" {
  description = "(Required) The ID of the Subnet to which the Bastion Host should be attached."
  type        = string
}

variable "frontend_ip_configuration_name" {
  description = "(Optional) The name of the Frontend IP Configuration."
  type        = string
  default     = "FrontendIPConfig"
}

variable "frontend_ports" {
  description = "(Optional) A list of Frontend Ports which should be used for the Application Gateway."
  type = list(object({
    name = string
    port = number
  }))
  default = [
    {
      name = "FrontendPort80"
      port = 80
    }
  ]
}

variable "backend_address_pools" {
  description = "(Optional) A list of Backend Address Pools which should be used for the Application Gateway."
  type = list(object({
    name         = string
    ip_addresses = list(string)
  }))
  default = [
    {
      name         = "BackendPool"
      ip_addresses = []
    }
  ]
}

variable "backend_http_settings" {
  description = "(Optional) A list of Backend HTTP Settings which should be used for the Application Gateway."
  type = list(object({
    name                  = string
    cookie_based_affinity = string
    path                  = string
    port                  = number
    protocol              = string
    request_timeout       = number
  }))
  default = [
    {
      name                  = "BackendHttpSettings"
      cookie_based_affinity = "Disabled"
      path                  = "/"
      port                  = 80
      protocol              = "Http"
      request_timeout       = 30
    }
  ]
}

variable "http_listeners" {
  description = "(Optional) A list of HTTP Listeners which should be used for the Application Gateway."
  type = list(object({
    name                           = string
    frontend_ip_configuration_name = string
    frontend_port_name             = string
    protocol                       = string
    host_name                      = string
  }))
  default = [
    {
      name                           = "HttpListener"
      frontend_ip_configuration_name = "FrontendIPConfig"
      frontend_port_name             = "FrontendPort80"
      protocol                       = "Http"
      host_name                      = ""
    }
  ]
}

variable "request_routing_rules" {
  description = "(Optional) A list of Request Routing Rules which should be used for the Application Gateway."
  type = list(object({
    name                       = string
    rule_type                  = string
    http_listener_name         = string
    backend_address_pool_name  = string
    backend_http_settings_name = string
    priority                   = number
  }))
  default = [
    {
      name                       = "RequestRoutingRule"
      rule_type                  = "Basic"
      http_listener_name         = "HttpListener"
      backend_address_pool_name  = "BackendPool"
      backend_http_settings_name = "BackendHttpSettings"
      priority                   = 100
    }
  ]
}

variable "public_ip_address_id" {
  description = "(Required) The ID of the Public IP Address to which the Bastion Host should be attached."
  type        = string
}

variable "module_tags" {
  description = "(Optional) Include the default tags?"
  type        = bool
  default     = true
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = null
}