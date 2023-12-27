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

variable "policy_settings_enabled" {
  description = "(Optional) Is the Application Gateway enabled?."
  type        = bool
  default     = true
}

variable "policy_settings_mode" {
  description = "(Optional) The operating mode for the Application Gateway. Possible values are WAF or Detection. Defaults to Detection."
  type        = string
  default     = "Detection"
}

variable "policy_settings_request_body_check" {
  description = "(Optional) Should the Application Gateway inspect the request body?."
  type        = bool
  default     = false
}

variable "policy_settings_file_upload_limit_in_mb" {
  description = "(Optional) The maximum file upload size in MB."
  type        = number
  default     = 100
}

variable "policy_settings_max_request_body_size_in_kb" {
  description = "(Optional) The maximum request body size in KB."
  type        = number
  default     = 128
}

variable "managed_rule_set_type" {
  type    = string
  default = "OWASP"
}

variable "managed_rule_set_version" {
  type    = string
  default = "3.2"
}

variable "exclusion_configuration" {
  type = list(object({
    match_variable          = string
    selector                = string
    selector_match_operator = string
    excluded_rule_set_configuration = list(object({
      type    = string
      version = string
      rule_group_configuration = list(object({
        rule_group_name = string
        excluded_rules  = list(string)
      }))
    }))
  }))
  default = []
}

variable "custom_rules_configuration" {
  type = list(object({
    name      = string
    priority  = number
    rule_type = string
    action    = string
    match_conditions_configuration = list(object({
      match_variable_configuration = list(object({
        match_variable = string
        selector       = string
      }))
      match_values       = list(string)
      operator           = string
      negation_condition = string
      transforms         = list(string)
    }))
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