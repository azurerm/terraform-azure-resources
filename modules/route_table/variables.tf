variable "custom_name" {
  description = "(Optional) The name of the Route Table."
  type        = string
  default     = ""
}

variable "workload" {
  description = "(Optional) The usage or application of the Route Table."
  type        = string
  default     = ""
}

variable "environment" {
  description = "(Optional) The environment of the Route Table."
  type        = string
  default     = ""
}

variable "location" {
  description = "(Required) The location/region where the Route Table is created. Changing this forces a new resource to be created."
  type        = string
}

variable "instance" {
  description = "(Optional) The instance count for the Route Table."
  type        = string
  default     = ""
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Route Table."
  type        = string
}

variable "bgp_route_propagation_enabled" {
  description = "(Optional) Should BGP route propagation be enabled? Defaults to true."
  type        = bool
  default     = true
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