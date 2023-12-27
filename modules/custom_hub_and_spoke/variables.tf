variable "workload" {
  description = "(Optional) The usage of the Hub."
  type        = string
  default     = "hub"
}

variable "environment" {
  description = "(Optional) The environment of the Hub."
  type        = string
  default     = "prd"
}

variable "location" {
  description = "(Required) The location/region where the Virtual Network is created. Changing this forces a new resource to be created."
  type        = string
}

variable "instance" {
  description = "(Optional) The instance count for the Hub."
  type        = string
  default     = "001"
}

variable "address_space_hub" {
  description = "(Required) The address space that is used the Hub."
  type        = list(string)
}

variable "dns_servers" {
  description = "(Optional) The DNS servers to be used with the Hub."
  type        = list(string)
  default     = null
}

variable "firewall" {
  description = "(Optional) Include a Firewall."
  type        = bool
  default     = true
}

variable "gateway" {
  description = "(Optional) Include a Gateway."
  type        = bool
  default     = true
}

variable "bastion" {
  description = "(Optional) Include a Bastion Host."
  type        = bool
  default     = true
}

variable "key_vault" {
  description = "(Optional) Include a Key Vault."
  type        = bool
  default     = true
}

variable "address_space_spoke" {
  description = "(Required) The address space that is used the Virtual Network."
  type = list(object({
    workload      = string
    environment   = string
    instance      = string
    address_space = list(string)
  }))
}

variable "spoke_dns" {
  description = "(Optional) Include a Spoke DNS."
  type        = bool
  default     = true
}

variable "address_space_spoke_dns" {
  description = "(Optional) The address space that is used the Virtual Network."
  type        = list(string)
  default     = null
}

variable "spoke_jumphost" {
  description = "(Optional) Include a Spoke Jump Host."
  type        = bool
  default     = false
}

variable "address_space_spoke_jumphost" {
  description = "(Optional) The address space that is used the Virtual Network."
  type        = list(string)
  default     = null
}

variable "spoke_dmz" {
  description = "(Optional) Include a DMZ Spoke."
  type        = bool
  default     = false
}

variable "address_space_spoke_dmz" {
  description = "(Optional) The address space that is used the Virtual Network."
  type        = list(string)
  default     = null
}

variable "web_application_firewall" {
  description = "(Optional) Include a WAF."
  type        = bool
  default     = false
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