variable "custom_name" {
  description = "(Optional) The name of the Virtual Network."
  type        = string
  default     = ""
}

variable "target_resource_id" {
  description = "The ID of the resource to apply the diagnostic setting to."
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace to send Diagnostic Logs to."
  type        = string
}
