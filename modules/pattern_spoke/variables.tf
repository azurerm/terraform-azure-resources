variable "workload" {
  description = "(Required) The usage or application of the Virtual Network."
  type        = string
}

variable "environment" {
  description = "(Required) The environment of the Virtual Network."
  type        = string
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

variable "subnet_count" {
  description = "(Optional) The number of subnets to be created within the Virtual Network."
  type        = number
  default     = 1
}

variable "linux_virtual_machine" {
  description = "(Optional) Include one Linux VM created per subnet."
  type        = bool
  default     = true
}

variable "windows_virtual_machine" {
  description = "(Optional) Include one Windows VM created per subnet."
  type        = bool
  default     = true
}

variable "virtual_machine_size" {
  description = "(Optional) The size of the Virtual Machine."
  type        = string
  default     = "Standard_B1ls"
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

variable "monitor_agent" {
  description = "(Optional) Include monitoring."
  type        = bool
  default     = false
}

variable "watcher_agent" {
  description = "(Optional) Include watcher."
  type        = bool
  default     = false
}

variable "update_management" {
  description = "(Optional) Include update management."
  type        = bool
  default     = false
}

variable "network_security_group" {
  description = "(Optional) Include a Network Security Group."
  type        = bool
  default     = false
}

variable "network_security_rules" {
  description = "(Optional) A list of Network Security Rules."
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = [
    {
      name                       = "A-IN-Net10-Net10"
      priority                   = 1000
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "10.0.0.0/8"
      destination_address_prefix = "10.0.0.0/8"
    },
    {
      name                       = "A-IN-AzureLoadBalancer-Any"
      priority                   = 4095
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "AzureLoadBalancer"
      destination_address_prefix = "*"
    },
    {
      name                       = "D-IN-Any-Any"
      priority                   = 4096
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "A-OUT-Net10-Net10"
      priority                   = 1000
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "10.0.0.0/8"
      destination_address_prefix = "10.0.0.0/8"
    },
    {
      name                       = "A-OUT-Net10-Internet-TCP-80"
      priority                   = 1005
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "10.0.0.0/8"
      destination_address_prefix = "Internet"
    },
    {
      name                       = "A-OUT-Net10-Internet-TCP-443"
      priority                   = 1010
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "10.0.0.0/8"
      destination_address_prefix = "Internet"
    },
    {
      name                       = "A-OUT-Net10-AzureKMS1-TCP-1688"
      priority                   = 1015
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "1688"
      source_address_prefix      = "10.0.0.0/8"
      destination_address_prefix = "20.118.99.224"
    },
    {
      name                       = "A-OUT-Net10-AzureKMS2-TCP-1688"
      priority                   = 1020
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "1688"
      source_address_prefix      = "10.0.0.0/8"
      destination_address_prefix = "40.83.235.53"
    },
    {
      name                       = "A-OUT-Net10-AzureNTP1-UDP-123"
      priority                   = 1025
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "123"
      source_address_prefix      = "10.0.0.0/8"
      destination_address_prefix = "51.145.123.29"
    },
    {
      name                       = "A-OUT-Net10-AzureNTP2-UDP-123"
      priority                   = 1030
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = "123"
      source_address_prefix      = "10.0.0.0/8"
      destination_address_prefix = "51.137.137.111"
    },
    {
      name                       = "D-OUT-Any-Any"
      priority                   = 4096
      direction                  = "Outbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
}

variable "single_route_table" {
  description = "(Optional) Use a single Route Table for all the Applications Spokes."
  type        = bool
  default     = false
}

variable "route_table_id" {
  description = "(Optianal) The Route Table ID only used if single_route_table is set to true."
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