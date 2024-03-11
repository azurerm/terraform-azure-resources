variable "custom_name" {
  description = "(Optional) The name of the Recovery Services Vault."
  type        = string
  default     = ""
}

variable "workload" {
  description = "(Optional) The usage or application of the Recovery Services Vault."
  type        = string
  default     = ""
}

variable "environment" {
  description = "(Optional) The environment of the Recovery Services Vault."
  type        = string
  default     = ""
}

variable "location" {
  description = "(Required) The location/region where the Recovery Services Vault is created. Changing this forces a new resource to be created."
  type        = string
}

variable "instance" {
  description = "(Optional) The instance count for the Recovery Services Vault."
  type        = string
  default     = ""
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Recovery Services Vault."
  type        = string
}

variable "sku" {
  description = "(Optional) The SKU of the Recovery Services Vault."
  type        = string
  default     = "Standard"
}

variable "immutability" {
  description = "(Optional) The immutability settings for the Recovery Services Vault."
  type        = string
  default     = "Disabled"
}

variable "storage_mode_type" {
  description = "(Optional) The storage mode of the Recovery Services Vault."
  type        = string
  default     = "LocallyRedundant"
}

variable "cross_region_restore_enabled" {
  description = "(Optional) Is cross region restore enabled for the Recovery Services Vault."
  type        = bool
  default     = false
}

variable "soft_delete_enabled" {
  description = "(Optional) Is soft delete enabled for the Recovery Services Vault."
  type        = bool
  default     = false
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