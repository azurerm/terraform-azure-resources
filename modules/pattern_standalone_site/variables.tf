variable "workload" {
  description = "(Required) The usage or application of the ressources."
  type        = string
  default     = "standalone"
}

variable "environment" {
  description = "(Required) The environment of the ressources."
  type        = string
  default     = "prd"
}

variable "location" {
  description = "(Required) The location/region where the Virtual Network is created. Changing this forces a new resource to be created."
  type        = string
}

variable "instance" {
  description = "(Optional) The instance count for the ressources."
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

variable "gateway" {
  description = "(Optional) Include a Gateway."
  type        = bool
  default     = false
}

variable "asn" {
  description = "(Optional) The ASN of the Gateway."
  type        = number
  default     = 0
}

variable "firewall" {
  description = "(Optional) Include a Firewall."
  type        = bool
  default     = false
}

variable "linux_virtual_machine" {
  description = "(Optional) Include one Linux VM created per subnet."
  type        = bool
  default     = true
}

variable "windows_virtual_machine" {
  description = "(Optional) Include one Windows VM created per subnet."
  type        = bool
  default     = false
}

variable "virtual_machine_size" {
  description = "(Optional) The size of the Virtual Machine."
  type        = string
  default     = "Standard_B1ls"
}

variable "additional_access_policy_object_ids" {
  description = "(Optional) An additional Object ID to add to the Key Vault Access Policy."
  type        = list(string)
  default     = []
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