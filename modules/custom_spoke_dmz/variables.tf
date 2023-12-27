variable "workload" {
  description = "(Optional) The usage or application of the Virtual Network."
  type        = string
  default     = "dmz"
}

variable "environment" {
  description = "(Optional) The environment of the Virtual Network."
  type        = string
  default     = "prd"
}

variable "location" {
  description = "(Required) The location/region where the Virtual Network is created. Changing this forces a new resource to be created."
  type        = string
}

variable "instance" {
  description = "(Optional) The instance count for the Virtual Network."
  type        = string
  default     = "001"
}

variable "address_space" {
  description = "(Required) The address space that is used the Virtual Network."
  type        = list(string)
}

variable "dns_servers" {
  description = "(Optional) The DNS servers to be used with the Virtual Network."
  type        = list(string)
  default     = null
}

variable "web_application_firewall" {
  description = "(Optional) Include a WAF."
  type        = bool
  default     = false
}

variable "firewall" {
  description = "(Optional) Firewall in Hub?."
  type        = bool
  default     = false
}

variable "next_hop" {
  description = "(Optional) The default next hop of the Virtual Network."
  type        = string
  default     = ""
}

variable "log_analytics_workspace_id" {
  description = "(Optional) The ID of the Log Analytics Workspace to log Application Gateway."
  type        = string
  default     = ""
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
