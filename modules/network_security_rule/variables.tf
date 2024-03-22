variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Virtual Network."
  type        = string
}

variable "name" {
  description = "(Required) The name of the network security rule."
  type        = string
}

variable "priority" {
  description = "(Required) The priority of the network security rule."
  type        = number
}

variable "direction" {
  description = "(Required) The direction of the network security rule. Possible values are Inbound and Outbound."
  type        = string
}

variable "access" {
  description = "(Optional) The Access of the network security rule. Possible values are Allow and Deny."
  type        = string
  default     = "Allow"
}

variable "protocol" {
  description = "(Optional) The network protocol this rule applies to. Possible values are Tcp, Udp, Icmp, Esp, * (which matches all protocols)."
  type        = string
  default     = "TCP"
}

variable "source_port_range" {
  description = "(Optional) The source port or range. Integer or range between 0 and 65535. Asterisk (*) can also be used to match all ports."
  type        = string
  default     = "*"
}

variable "destination_port_range" {
  description = "(Optional) The destination port or range. Integer or range between 0 and 65535. Asterisk (*) can also be used to match all ports."
  type        = string
  default     = "*"
}

variable "source_address_prefix" {
  description = "(Optional) The source address prefix. CIDR or * to match any IP address."
  type        = string
  default     = "*"
}

variable "destination_address_prefix" {
  description = "(Optional) The destination address prefix. CIDR or * to match any IP address."
  type        = string
  default     = "*"
}

variable "network_security_group_name" {
  description = "(Required) The name of the network security group to which to attach the rule."
  type        = string
}


