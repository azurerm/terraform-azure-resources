variable "custom_name" {
  description = "(Optional) The name of the Virtual Network."
  type        = string
  default     = ""
}

variable "workload" {
  description = "(Optional) The usage or application of the Subnet."
  type        = string
  default     = ""
}

variable "environment" {
  description = "(Optional) The environment of the Subnet."
  type        = string
  default     = ""
}

variable "location" {
  description = "(Required) The location/region where the Subnet is created. Changing this forces a new resource to be created."
  type        = string
}

variable "instance" {
  description = "(Optional) The instance count for the Subnet."
  type        = string
  default     = ""
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Subnet."
  type        = string
}

variable "address_prefixes" {
  description = "(Required) The address space that is used the Subnet."
  type        = list(string)
}

variable "virtual_network_name" {
  description = "(Required) The name of the Virtual Network in which to create the Subnet."
  type        = string
}

# variable "private_endpoint_network_policies_enabled" {
#   description = "(Optional) Is network policies enabled for private endpoints on this subnet."
#   type        = bool
#   default     = true
# }

variable "private_endpoint_network_policies" {
  description = "(Optional) Enable or Disable network policies for the private endpoint on the subnet."
  type        = string
  default     = "Enabled"
}

variable "private_link_service_network_policies_enabled" {
  description = "(Optional) Is network policies enabled for private link service on this subnet."
  type        = bool
  default     = false
}

variable "service_endpoints" {
  description = "(Optional) A list of service endpoints."
  type        = list(string)
  default     = []
}

variable "service_endpoint_policy_ids" {
  description = "(Optional) A list of service endpoint policy IDs."
  type        = list(string)
  default     = null
}

variable "delegation" {
  description = "(Optional) A map of delegation blocks."
  type = map(object({
    name    = string
    actions = list(string)
  }))
  default = {}
}
