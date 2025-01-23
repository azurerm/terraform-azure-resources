variable "workload" {
  description = "(Optional) The usage of the Hub."
  type        = string
  default     = "hub"
}

variable "workload_management" {
  description = "(Required) Management workload"
  type        = string
  default     = "mgt"
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

variable "firewall_sku" {
  description = "(Optional) The SKU of the Firewall."
  type        = string
  default     = "Standard"
}

variable "firewall_palo_alto" {
  description = "(Optional) Include a Palo Alto Firewall."
  type        = bool
  default     = false
}

variable "gateway" {
  description = "(Optional) Include a Gateway."
  type        = bool
  default     = true
}

variable "gateway_type" {
  description = "(Optional) The type of the Gateway."
  type        = string
  default     = "Vpn"
}

variable "gateway_sku" {
  description = "(Optional) The SKU of the Gateway."
  type        = string
  default     = "VpnGw1AZ"
}

variable "p2s_vpn" {
  description = "(Optional) Include a Point-to-Site VPN configuration."
  type        = bool
  default     = false
}

variable "bastion" {
  description = "(Optional) Include a Bastion Host."
  type        = bool
  default     = true
}

variable "bastion_sku" {
  description = "(Optional) The SKU of the Bastion Host."
  type        = string
  default     = "Basic"
}

variable "key_vault" {
  description = "(Optional) Include a Key Vault."
  type        = bool
  default     = true
}

variable "ip_filter" {
  description = "(Optional) Include an IP Filter."
  type        = bool
  default     = true
}

variable "private_paas" {
  description = "(Optional) Close any public access to the PaaS services (private connectivity is required)."
  type        = bool
  default     = false
}

variable "address_space_spokes" {
  description = "(Optional) The address space that is used the Virtual Network."
  type = list(object({
    workload         = string
    environment      = string
    instance         = string
    address_space    = list(string)
    virtual_machines = optional(bool, true)
  }))
  default = []
}

variable "spoke_dns" {
  description = "(Optional) Include a Spoke DNS."
  type        = bool
  default     = false
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

variable "spoke_ai" {
  description = "(Optional) Include a DMZ Spoke."
  type        = bool
  default     = false
}

variable "address_space_spoke_ai" {
  description = "(Optional) The address space that is used the Virtual Network."
  type        = list(string)
  default     = null
}

variable "private_monitoring" {
  description = "(Optional) Include a Private Monitoring."
  type        = bool
  default     = false
}

variable "address_space_spoke_private_monitoring" {
  description = "(Optional) The address space that is used the Virtual Network."
  type        = list(string)
  default     = null
}

variable "connection_monitor" {
  description = "(Optional) Include a Network Watcher Connection Monitor."
  type        = bool
  default     = false
}

variable "update_management" {
  description = "(Optional) Include Update Management for the Virtual Machine."
  type        = bool
  default     = false
}

variable "backup" {
  description = "(Optional) Include a backup configuration for the Virtual Machine."
  type        = bool
  default     = false
}

variable "network_security_group" {
  description = "(Optional) Include a Network Security Group with Flow Log."
  type        = bool
  default     = false
}

variable "additional_access_policy_object_ids" {
  description = "(Optional) An additional Object ID to add to the Key Vault Access Policy."
  type        = list(string)
  default     = []
}

variable "spokes_single_route_table" {
  description = "(Optional) Use a single Route Table for all the Applications Spokes."
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