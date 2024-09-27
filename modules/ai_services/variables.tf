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

variable "sku_name" {
  description = "(Optional) The SKU of the AI Services."
  type        = string
  default     = "S0"
}

variable "custom_subdomain_name" {
  description = "(Optional) The custom subdomain name of the AI Services."
  type        = string
  default     = null
}

variable "deployment_availability" {
  description = "(Optional) The deployment availability of the AI Services."
  type        = list(string)
  default     = ["australiaeast", "brazilsouth", "canadaeast", "eastus", "eastus2", "francecentral", "germanywestcentral", "japaneast", "koreacentral", "northcentralus", "norwayeast", "polandcentral", "southafricanorth", "southcentralus", "southindia", "swedencentral", "switzerlandnorth", "switzerlandwest", "uksouth", "westeurope", "westus", "westus3"]
}

variable "default_location" {
  description = "(Optional) The default location of the AI Services."
  type        = string
  default     = "swedencentral"
}

variable "fqdns" {
  description = "(Optional) The FQDNs of the AI Services."
  type        = list(string)
  default     = []
}

variable "local_authentication_enabled" {
  description = "(Optional) Is local authentication enabled for the AI Services?"
  type        = bool
  default     = true
}

variable "outbound_network_access_restricted" {
  description = "(Optional) Is outbound network access restricted for the AI Services?"
  type        = bool
  default     = false
}

variable "public_network_access" {
  description = "(Optional) Is public network access enabled for the AI Services?"
  type        = string
  default     = "Disabled"
}

variable "network_acls" {
  description = "(Optional) The network ACLs of the AI Services."
  type = list(object({
    default_action = string
    ip_rules       = list(string)
  }))
  default = [
    {
      default_action = "Deny"
      ip_rules       = []
    }
  ]
}

variable "identity" {
  description = "(Optional) The identity of the AI Services."
  type = list(object({
    type         = string
    identity_ids = optional(list(string), null)
  }))
  default = []
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