variable "workload" {
  description = "(Optional) The usage or application of the Virtual Network."
  type        = string
  default     = "dns"
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

variable "dns_forwarding_rules" {
  description = "(Optional) A list of DNS forwarding rules."
  type = list(object({
    domain_name = string
    target_dns_servers = list(object({
      ip_address = string
      port       = number
    }))
  }))
  default = []
}