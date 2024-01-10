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

variable "virtual_machine_id" {
  description = "(Required) The ID of the Virtual Machine to which the Extension should be added."
  type        = string
}

variable "publisher" {
  description = "(Required) The name of the extension publisher."
  type        = string
}

variable "type" {
  description = "(Required) The type of the extension."
  type        = string
}

variable "type_handler_version" {
  description = "(Required) Specifies the version of the script handler."
  type        = string
}

variable "settings" {
  description = "(Optional) A JSON string containing private configuration for the extension."
  type        = string
  default     = ""
}

variable "auto_upgrade_minor_version" {
  description = "(Optional) Should the extension be automatically upgraded across minor versions when Azure updates the extension?"
  type        = bool
  default     = false
}

variable "automatic_upgrade_enabled" {
  description = "(Optional) Should the extension be automatically upgraded when a new version is published?"
  type        = bool
  default     = false
}

variable "time_sleep" {
  description = "(Optional) The time to sleep before the next module."
  type        = string
  default     = "180s"
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