variable "custom_name" {
  description = "(Optional) The name of the Local Network Gateway."
  type        = string
  default     = ""
}

variable "workload" {
  description = "(Optional) The usage or application of the Local Network Gateway."
  type        = string
  default     = ""
}

variable "environment" {
  description = "(Optional) The environment of the Local Network Gateway."
  type        = string
  default     = ""
}

variable "location" {
  description = "(Required) The location/region where the Local Network Gateway is created. Changing this forces a new resource to be created."
  type        = string
}

variable "instance" {
  description = "(Optional) The instance count for the Local Network Gateway."
  type        = string
  default     = ""
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Local Network Gateway."
  type        = string
}

variable "gateway_address" {
  description = "(Optional) The IP address of the local network gateway."
  type        = string
  default     = null
}

variable "gateway_fqdn" {
  description = "(Optional) The FQDN of the local network gateway."
  type        = string
  default     = null
}

variable "address_space" {
  description = "(Optional) The address space of the local network gateway."
  type        = list(string)
  default     = []
}

variable "asn" {
  description = "(Optional) The ASN of the local network gateway."
  type        = string
  default     = ""
}

variable "bgp_peering_address" {
  description = "(Optional) The BGP peering address of the local network gateway."
  type        = string
  default     = ""
}

variable "peer_weight" {
  description = "(Optional) The peer weight of the local network gateway."
  type        = number
  default     = 0
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