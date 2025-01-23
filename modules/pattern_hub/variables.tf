variable "workload" {
  description = "(Required) Default workload"
  type        = string
  default     = "hub"
}

variable "workload_management" {
  description = "(Required) Management workload"
  type        = string
  default     = "mgt"
}

variable "environment" {
  description = "(Required) The environment of the Hub."
  type        = string
  default     = "prd"
}

variable "location" {
  description = "(Required) The location/region where the Hub is created. Changing this forces a new resource to be created."
  type        = string
}

variable "instance" {
  description = "(Optional) The instance count for the Hub."
  type        = string
  default     = "001"
}

variable "address_space" {
  description = "(Required) The address space that is used the Hub."
  type        = list(string)
}

variable "dns_servers" {
  description = "(Optional) The DNS servers to be used."
  type        = list(string)
  default     = null
}

variable "firewall" {
  description = "(Optional) Include a Firewall."
  type        = bool
  default     = true
}

variable "firewall_default_rules" {
  description = "(Optional) Include the default rules for the Firewall."
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

variable "asn" {
  description = "(Optional) The ASN of the Gateway."
  type        = number
  default     = 0
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

variable "storage_account" {
  description = "(Optional) Include a Storage Account."
  type        = bool
  default     = true
}

variable "ip_filter" {
  description = "(Optional) Include an IP Filter."
  type        = bool
  default     = false
}

variable "additional_access_policy_object_ids" {
  description = "(Optional) An additional Object ID to add to the Key Vault Access Policy."
  type        = list(string)
  default     = []
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