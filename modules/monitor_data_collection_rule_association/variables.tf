variable "name" {
  description = "(Optional) The name of the Data Collection Rule Association."
  type        = string
  default     = null
}

variable "target_resource_id" {
  description = "(Required) The ID of the resource to monitore."
  type        = string
}

variable "data_collection_rule_id" {
  description = "(Optional) The ID of the Data Collection Rule."
  type        = string
  default     = null
}

variable "data_collection_endpoint_id" {
  description = "(Optional) The ID of the Data Collection Endpoint."
  type        = string
  default     = null
}

variable "description" {
  description = "(Optional) The description of the Data Collection Rule Association."
  type        = string
  default     = ""
}