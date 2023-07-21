variable "workload" {
  description = "(Required) The usage or application of the Virtual Network."
  type        = string
}

variable "environment" {
  description = "(Required) The environment of the Virtual Network."
  type        = string
}

variable "location" {
  description = "(Required) The location/region where the Virtual Network is created. Changing this forces a new resource to be created."
  type        = string
}

variable "instance" {
  description = "(Optional) The instance count for the Virtual Network."
  type        = string
  default     = "001"
}

variable "address_space" {
  description = "(Required) The address space that is used the Virtual Network."
  type        = list(string)
}

variable "dns_servers" {
  description = "(Optional) The DNS servers to be used with the Virtual Network."
  type        = list(string)
  default     = null
}

variable "subnet_count" {
  description = "(Optional) The number of subnets to be created within the Virtual Network."
  type        = number
  default     = 1
}

variable "linux_virtual_machine" {
  description = "(Optional) Include one Linux VM created per subnet."
  type        = bool
  default     = true
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