variable "location" {
  type    = string
  default = "northeurope"
}

variable "firewall" {
  type    = bool
  default = false
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

variable "bastion" {
  type    = bool
  default = false
}

variable "address_space_hub" {
  type    = list(string)
  default = ["10.100.0.0/24"]
}

variable "spoke_dns" {
  type    = bool
  default = false
}

variable "address_space_spoke_dns" {
  type    = list(string)
  default = []
}

variable "spoke_dmz" {
  type    = bool
  default = false
}

variable "address_space_spoke_dmz" {
  type    = list(string)
  default = []
}

variable "private_monitoring" {
  type    = bool
  default = false
}

variable "address_space_spoke_private_monitoring" {
  type    = list(string)
  default = []
}

variable "spoke_ai" {
  type    = bool
  default = false
}

variable "address_space_spoke_ai" {
  type    = list(string)
  default = []
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

variable "address_space_spokes" {
  type = list(object({
    workload        = string
    environment     = string
    instance        = string
    address_space   = list(string)
    virtual_machine = optional(bool, true)
  }))
  default = [
    {
      workload      = "app1"
      environment   = "dev"
      instance      = "001"
      address_space = ["10.100.10.0/24"]
    },
    {
      workload      = "app1"
      environment   = "prd"
      instance      = "001"
      address_space = ["10.100.11.0/24"]
    }
  ]
}

variable "standalone_site" {
  type    = number
  default = 0
}

variable "address_space_standalone_site" {
  type    = list(string)
  default = ["10.200.0.0/23"]
}

module "hub_and_spoke" {
  source                                 = "../modules/pattern_hub_and_spoke"
  location                               = var.location
  firewall                               = var.firewall
  firewall_sku                           = var.firewall_sku
  firewall_palo_alto                     = var.firewall_palo_alto
  gateway                                = var.gateway
  bastion                                = var.bastion
  address_space_hub                      = var.address_space_hub
  spoke_dns                              = var.spoke_dns
  address_space_spoke_dns                = var.address_space_spoke_dns
  spoke_dmz                              = var.spoke_dmz
  address_space_spoke_dmz                = var.address_space_spoke_dmz
  spoke_ai                               = var.spoke_ai
  address_space_spoke_ai                 = var.address_space_spoke_ai
  web_application_firewall               = var.spoke_dmz
  private_monitoring                     = var.private_monitoring
  address_space_spoke_private_monitoring = var.address_space_spoke_private_monitoring
  connection_monitor                     = var.connection_monitor
  update_management                      = var.update_management
  network_security_group                 = var.network_security_group
  backup                                 = var.backup
  address_space_spokes                   = var.address_space_spokes
}

module "standalone_site" {
  source        = "../modules/pattern_standalone_site"
  count         = var.standalone_site
  location      = var.location
  address_space = var.address_space_standalone_site
}