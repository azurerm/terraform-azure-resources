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

variable "sku" {
  description = "(Optional) The SKU of the Bastion Host."
  type        = string
  default     = "Basic"
}

variable "copy_paste_enabled" {
  description = "(Optional) Is copy/paste enabled for the Bastion Host?"
  type        = bool
  default     = true
}

variable "file_copy_enabled" {
  description = "(Optional) Is file copy enabled for the Bastion Host?"
  type        = bool
  default     = false
}

variable "ip_connect_enabled" {
  description = "(Optional) Is IP connect enabled for the Bastion Host?"
  type        = bool
  default     = false
}

variable "scale_units" {
  description = "(Optional) The number of scale units for the Bastion Host."
  type        = number
  default     = 2
}

variable "shareable_link_enabled" {
  description = "(Optional) Is shareable link enabled for the Bastion Host?"
  type        = bool
  default     = false
}

variable "tunneling_enabled" {
  description = "(Optional) Is tunneling enabled for the Bastion Host?"
  type        = bool
  default     = false
}

variable "ip_configuration_name" {
  description = "(Optional) The name of the IP Configuration."
  type        = string
  default     = "ipconfig"
}

variable "subnet_id" {
  description = "(Optional) The ID of the Subnet to which the Bastion Host should be attached."
  type        = string
  default     = null
}

variable "public_ip_address_id" {
  description = "(Optional) The ID of the Public IP Address to which the Bastion Host should be attached."
  type        = string
  default     = null
}

variable "virtual_network_id" {
  description = "(Optional) The ID of the Virtual Network for the Developer Bastion Host. Changing this forces a new resource to be created."
  type        = string
  default     = null
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