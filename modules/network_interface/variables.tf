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

variable "ip_configuration_name" {
  description = "(Optional) The name of the IP Configuration."
  type        = string
  default     = "ipconfig"
}

variable "enable_ip_forwarding" {
  description = "(Optional) Should IP Forwarding be enabled on the Network Interface?"
  type        = bool
  default     = false
}

variable "enable_accelerated_networking" {
  description = "(Optional) Should Accelerated Networking be enabled on the Network Interface?"
  type        = bool
  default     = false
}

variable "private_ip_address_allocation" {
  description = "(Optional) The allocation method of the Private IP Address."
  type        = string
  default     = "Dynamic"
}

variable "subnet_id" {
  description = "(Required) The ID of the Subnet which should be used with the Network Interface."
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
