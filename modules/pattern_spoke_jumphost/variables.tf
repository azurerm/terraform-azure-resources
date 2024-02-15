variable "workload" {
  description = "(Optional) The usage or application of the Virtual Network."
  type        = string
  default     = "jump"
}

variable "environment" {
  description = "(Optional) The environment of the Virtual Network."
  type        = string
  default     = "prd"
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

variable "linux_virtual_machine" {
  description = "(Optional) Include one Linux VM created per subnet."
  type        = bool
  default     = true
}

variable "windows_virtual_machine" {
  description = "(Optional) Include one Windows VM created per subnet."
  type        = bool
  default     = true
}

variable "virtual_machine_size" {
  description = "(Optional) The size of the Virtual Machine."
  type        = string
  default     = "Standard_B1ls"
}

variable "firewall" {
  description = "(Optional) Firewall in Hub?."
  type        = bool
  default     = false
}

variable "default_next_hop" {
  description = "(Optional) The default next hop of the Virtual Network."
  type        = string
  default     = ""
}

variable "firewall_policy_id" {
  description = "(Optional) The ID of the Firewall Policy."
  type        = string
  default     = ""
}

variable "firewall_public_ip" {
  description = "(Optional) The public IP address of the Firewall."
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
