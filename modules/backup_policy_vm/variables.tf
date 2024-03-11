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
  description = "(Optional) The location/region where the Recovery Services Vault is created. Changing this forces a new resource to be created."
  type        = string
  default     = ""
}

variable "instance" {
  description = "(Optional) The instance count for the Recovery Services Vault."
  type        = string
  default     = ""
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group where the Recovery Services Vault is located."
  type        = string
}

variable "recovery_vault_name" {
  description = "(Required) The name of the Recovery Services Vault."
  type        = string
}

variable "timezone" {
  description = "(Optional) The timezone of the backup policy."
  type        = string
  default     = "UTC"
}

variable "backup_frequency" {
  description = "(Optional) The frequency of the backup policy."
  type        = string
  default     = "Daily"
}

variable "backup_time" {
  description = "(Optional) The time of the backup policy."
  type        = string
  default     = "01:00"
}

variable "instant_restore_retention_days" {
  description = "(Optional) The number of days to retain Instant Restore snapshots."
  type        = number
  default     = 2
}

variable "retention_daily_count" {
  description = "(Optional) The number of daily backups to retain."
  type        = number
  default     = 14
}
