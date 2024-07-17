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

variable "gateway_1_id" {
  description = "(Required) The ID of the virtual network gateway 1."
  type        = string
}

variable "gateway_2_id" {
  description = "(Required) The ID of the virtual network gateway 2."
  type        = string
}

variable "vault_psk" {
  description = "(Optional) Store the PSK in a Key Vault?"
  type        = bool
  default     = false
}

variable "key_vault_id" {
  description = "(Optional) The ID of the Key Vault."
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