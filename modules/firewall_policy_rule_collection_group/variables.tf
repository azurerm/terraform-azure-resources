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

variable "base_policy_id" {
  description = "(Optional) The ID of the base policy to use for this Firewall Policy."
  type        = string
  default     = null
}

variable "private_ip_ranges" {
  description = "(Optional) A list of private IP address ranges to be used by the Firewall Policy."
  type        = list(string)
  default     = null
}

variable "auto_learn_private_ranges_enabled" {
  description = "(Optional) Is auto-learning of private IP address ranges enabled?"
  type        = bool
  default     = false
}

variable "sku" {
  description = "(Optional) The SKU of the Firewall Policy."
  type        = string
  default     = "Standard"
}

variable "threat_intelligence_mode" {
  description = "(Optional) The Threat Intelligence mode of the Firewall Policy."
  type        = string
  default     = "Alert"
}

variable "sql_redirect_allowed" {
  description = "(Optional) Is SQL redirect allowed?"
  type        = bool
  default     = false
}

variable "dns_proxy_enabled" {
  description = "(Optional) Is DNS Proxy enabled?"
  type        = bool
  default     = false
}

variable "dns_servers" {
  description = "(Optional) The DNS servers to be used with the Virtual Network."
  type        = list(string)
  default     = null
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