variable "custom_name" {
  description = "(Optional) The name of the Maintenance Configuration."
  type        = string
  default     = ""
}

variable "workload" {
  description = "(Optional) The usage or application of the Maintenance Configuration."
  type        = string
  default     = ""
}

variable "environment" {
  description = "(Optional) The environment of the Maintenance Configuration."
  type        = string
  default     = ""
}

variable "location" {
  description = "(Required) The location/region where the Resource Group is created. Changing this forces a new resource to be created."
  type        = string
}

variable "instance" {
  description = "(Optional) The instance count for the Maintenance Configuration."
  type        = string
  default     = ""
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Maintenance Configuration."
  type        = string
}

variable "scope" {
  description = "(Required) The scope of the Maintenance Configuration."
  type        = string
}

variable "in_guest_user_patch_mode" {
  description = "(Optional) The in-guest user patch mode of the Maintenance Configuration."
  type        = string
  default     = "User"
}

variable "window_start_date_time" {
  description = "(Required) The start date and time of the Maintenance Configuration."
  type        = string
}

variable "window_duration" {
  description = "(Optional) The duration of the Maintenance Configuration."
  type        = string
  default     = "03:00"
}

variable "window_expiration_date_time" {
  description = "(Optional) The end date and time of the Maintenance Configuration."
  type        = string
  default     = ""
}

variable "window_time_zone" {
  description = "(Optional) The time zone of the Maintenance Configuration."
  type        = string
  default     = "Romance Standard Time"
}

variable "window_recur_every" {
  description = "(Optional) The recurrence of the Maintenance Configuration."
  type        = string
  default     = "1Week Monday"
}

variable "linux_classifications_to_include" {
  description = "(Optional) The classification of the Linux patches."
  type        = list(string)
  default     = ["Critical", "Security", "Other"]
}

variable "linux_package_names_mask_to_include" {
  description = "(Optional) The included patches for the Linux patches."
  type        = list(string)
  default     = []
}

variable "linux_package_names_mask_to_exclude" {
  description = "(Optional) The excluded patches for the Linux patches."
  type        = list(string)
  default     = []
}

variable "windows_classifications_to_include" {
  description = "(Optional) The classification of the Windows patches."
  type        = list(string)
  default     = ["Critical", "Security", "UpdateRollup", "FeaturePack", "Updates", "Definition"]
}

variable "windows_kb_numbers_to_include" {
  description = "(Optional) The included patches for the Windows patches."
  type        = list(string)
  default     = []
}

variable "windows_kb_numbers_to_exclude" {
  description = "(Optional) The excluded patches for the Windows patches."
  type        = list(string)
  default     = []
}

variable "reboot" {
  description = "(Optional) Reboot the system after the patches are installed."
  type        = string
  default     = "Never"
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
