variable "subscription_id" {
  type = string
}

variable "ip_filter" {
  type    = bool
  default = false
}

variable "private_paas" {
  type    = bool
  default = false
}

variable "location" {
  type    = string
  default = "francecentral"
}

variable "firewall" {
  type    = bool
  default = true
}

variable "firewall_sku" {
  type    = string
  default = "Standard"
}

variable "firewall_palo_alto" {
  type    = bool
  default = false
}

variable "gateway" {
  type    = bool
  default = false
}

variable "p2s_vpn" {
  type    = bool
  default = false
}

variable "bastion" {
  type    = bool
  default = true
}

variable "key_vault" {
  type    = bool
  default = true
}

variable "address_space_hub" {
  type    = list(string)
  default = ["10.100.0.0/24"]
}

variable "spoke_dns" {
  type    = bool
  default = true
}

variable "address_space_spoke_dns" {
  type    = list(string)
  default = ["10.100.1.0/24"]
}

variable "spoke_dmz" {
  type    = bool
  default = true
}

variable "address_space_spoke_dmz" {
  type    = list(string)
  default = ["10.100.2.0/24"]
}

variable "private_monitoring" {
  type    = bool
  default = false
}

variable "address_space_spoke_private_monitoring" {
  type    = list(string)
  default = ["10.100.3.0/27"]
}

variable "spoke_ai" {
  type    = bool
  default = false
}

variable "address_space_spoke_ai" {
  type    = list(string)
  default = ["10.100.4.0/25"]
}

variable "connection_monitor" {
  type    = bool
  default = false
}

variable "update_management" {
  type    = bool
  default = false
}

variable "network_security_group" {
  type    = bool
  default = false
}

variable "backup" {
  type    = bool
  default = false
}

variable "spokes_count" {
  type    = number
  default = 2
}

variable "spokes_virtual_machines" {
  type    = bool
  default = true
}

variable "additional_access_policy_object_ids" {
  type    = list(string)
  default = ["70d8c1d0-cad7-4526-9991-210fdeac1574"]
}

variable "standalone_site" {
  type    = number
  default = 0
}
