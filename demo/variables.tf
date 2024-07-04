variable "ip_filter" {
  type    = bool
  default = false
}

variable "location" {
  type    = string
  default = "northeurope"
}

variable "firewall" {
  type    = bool
  default = true
}

variable "gateway" {
  type    = bool
  default = false
}

variable "bastion" {
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

# variable "address_space_spokes" {
#   type = list(object({
#     workload        = string
#     environment     = string
#     instance        = string
#     address_space   = list(string)
#     virtual_machine = optional(bool, true)
#   }))
#   default = [
#     {
#       workload      = "app1"
#       environment   = "dev"
#       instance      = "001"
#       address_space = ["10.100.10.0/24"]
#     },
#     {
#       workload      = "app1"
#       environment   = "prd"
#       instance      = "001"
#       address_space = ["10.100.110.0/24"]
#     }
#   ]
# }

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
  default = ["a3e0a76c-f251-447d-8244-e47dbe6746e3", "12238d65-4cc0-4114-b51e-2f39b0075dce"]
}

variable "standalone_site" {
  type    = bool
  default = false
}

variable "address_space_standalone_site" {
  type    = list(string)
  default = ["10.200.0.0/23"]
}