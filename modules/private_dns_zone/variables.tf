variable "name" {
  description = "The name of the Private DNS Zone."
  type        = string
  default     = ""
}

variable "workload" {
  description = "(Optional) The usage or application of the Private DNS Resolver."
  type        = string
  default     = "dns"
}

variable "environment" {
  description = "(Optional) The environment of the Private DNS Resolver."
  type        = string
  default     = "prd"
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Virtual Network."
  type        = string
}

variable "virtual_network_link" {
  description = "(Optional) The ID of the Virtual Network Link to associate with the Private DNS Resolver."
  type        = string
  default     = false
}

variable "virtual_network_id" {
  description = "(Optional) The ID of the Virtual Network in which to create the Private DNS Resolver."
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