variable "custom_name" {
  description = "(Optional) The name of the Virtual Network."
  type        = string
  default     = ""
}

variable "workload" {
  description = "(Optional) The usage or application of the Virtual Network."
  type        = string
  default     = ""
}

variable "environment" {
  description = "(Optional) The environment of the Virtual Network."
  type        = string
  default     = ""
}

variable "location" {
  description = "(Required) The location/region where the Virtual Network is created. Changing this forces a new resource to be created."
  type        = string
}

variable "instance" {
  description = "(Optional) The instance count for the Virtual Network."
  type        = string
  default     = ""
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Virtual Network."
  type        = string
}

variable "type" {
  description = "(Optional) The type of the Virtual Network Gateway : ExpressRoute or Vpn."
  type        = string
  default     = "Vpn"

}

variable "vpn_type" {
  description = "(Optional) The type of this Virtual Network Gateway : PolicyBased or RouteBased."
  type        = string
  default     = "RouteBased"
}

variable "active_active" {
  description = "(Optional) Is Active Active?"
  type        = bool
  default     = false
}

variable "enable_bgp" {
  description = "(Optional) Is BGP Enabled?"
  type        = bool
  default     = true
}

variable "sku" {
  description = "(Optional) The Sku name of the Virtual Network Gateway."
  type        = string
  default     = "VpnGw1AZ"
}

variable "asn" {
  description = "(Optional) The BGP speaker's ASN. Default is set to 65000 to avoid conflit with Azure default ASN. If set to 0, random ASN is generated"
  type        = number
  default     = 65000
}

variable "ip_configurations" {
  description = "(Required) List of IP configuration of the Gateway"
  type = list(object({
    name                          = optional(string, "ipconfig")
    public_ip_address_id          = string
    private_ip_address_allocation = optional(string, "Dynamic")
    subnet_id                     = string
  }))
}

variable "p2s_vpn" {
  description = "(Optional) Include a Point-to-Site VPN configuration."
  type        = bool
  default     = false
}

variable "address_space" {
  description = "(Optional) The address space that is used the Hub."
  type        = list(string)
  default     = ["10.99.255.0/24"]
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