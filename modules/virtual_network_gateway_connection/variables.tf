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

variable "type" {
  description = "(Optional) The type of connection."
  type        = string
  default     = "IPsec"
}

variable "virtual_network_gateway_id" {
  description = "(Required) The ID of the virtual network gateway."
  type        = string
}

variable "local_network_gateway_id" {
  description = "(Required) The ID of the local network gateway."
  type        = string
}

variable "shared_key" {
  description = "(Required) The shared key."
  type        = string
}

variable "connection_mode" {
  description = "(Optional) The connection mode."
  type        = string
  default     = "Default"
}

variable "routing_weight" {
  description = "(Optional) The routing weight."
  type        = number
  default     = 10
}

variable "connection_protocol" {
  description = "(Optional) The connection protocol."
  type        = string
  default     = "IKEv2"
}

variable "enable_bgp" {
  description = "(Optional) Is BGP Enabled?"
  type        = bool
  default     = false
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