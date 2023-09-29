variable "custom_name" {
  description = "(Optional) The name of the Private DNS Resolver Forwarding Rule Set."
  type        = string
  default     = ""
}

variable "custom_name_link" {
  description = "(Optional) The name of the Private DNS Resolver Forwarding Rule Set Link."
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

variable "location" {
  description = "(Required) The location/region where the Private DNS Resolver is created. Changing this forces a new resource to be created."
  type        = string
}

variable "instance" {
  description = "(Optional) The instance count for the Private DNS Resolver."
  type        = string
  default     = "001"
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Virtual Network."
  type        = string
}

variable "virtual_network_id" {
  description = "(Required) The ID of the Virtual Network in which to create the Private DNS Resolver."
  type        = string
}

variable "private_dns_resolver_outbound_endpoint_ids" {
  description = "(Required) The ID of the subnet to use for the Private DNS Resolver Inbound Endpoint."
  type        = list(string)
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