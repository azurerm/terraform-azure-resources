variable "virtual_network_1_resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Virtual Network."
  type        = string
}

variable "virtual_network_1_id" {
  description = "(Required) The name of the Virtual Network."
  type        = string
}

variable "virtual_network_2_resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Virtual Network."
  type        = string
}

variable "virtual_network_2_id" {
  description = "(Required) The name of the Virtual Network."
  type        = string
}

variable "virtual_network_1_hub" {
  description = "(Optional) Is Virtual Network 1 hub?"
  type        = bool
  default     = false
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
