variable "custom_name" {
  description = "(Optional) The name of the Virtual Network."
  type        = string
  default     = ""
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Virtual Network."
  type        = string
}

variable "virtual_network_name" {
  description = "(Required) The name of the Virtual Network."
  type        = string
}

variable "remote_virtual_network_id" {
  description = "(Required) The ID of the remote Virtual Network to peer with."
  type        = string
}

variable "allow_virtual_network_access" {
  description = "(Optional) Controls if the VMs in the remote Virtual Network can access VMs in the local Virtual Network."
  type        = bool
  default     = true
}

variable "allow_forwarded_traffic" {
  description = "(Optional) Controls if forwarded traffic from VMs in the remote Virtual Network is allowed."
  type        = bool
  default     = true
}

variable "allow_gateway_transit" {
  description = "(Optional) Controls gatewayLinks can be used in the remote Virtual Network’s link to the local Virtual Network."
  type        = bool
  default     = false
}

variable "use_remote_gateways" {
  description = "(Optional) Controls if remote gateways can be used on the local Virtual Network."
  type        = bool
  default     = false
}
