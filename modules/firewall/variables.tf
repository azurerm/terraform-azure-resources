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

variable "sku_name" {
  description = "(Optional) SKU name of the Firewall."
  type        = string
  default     = "AZFW_VNet"
}

variable "sku_tier" {
  description = "(Optional) SKU tier of the Firewall."
  type        = string
  default     = "Standard"
}

variable "firewall_policy_id" {
  description = "(Optional) The ID of the Firewall Policy."
  type        = string
  default     = null
}

variable "dns_servers" {
  description = "(Optional) A list of DNS servers that the Azure Firewall will direct DNS traffic to the for name resolution."
  type        = list(string)
  default     = null
}

variable "private_ip_ranges" {
  description = "(Optional) A list of private IP address ranges that will be used by subnets."
  type        = list(string)
  default     = null
}

variable "threat_intel_mode" {
  description = "(Optional) The operation mode for Threat Intelligence."
  type        = string
  default     = "Alert"
}

variable "zones" {
  description = "(Optional) A list of availability zones which to deploy the firewall in."
  type        = list(string)
  default     = ["1", "2", "3"]
}

variable "ip_configuration_name" {
  description = "(Optional) The name of the IP Configuration."
  type        = string
  default     = "ipconfig"
}

variable "public_ip_address_id" {
  description = "(Required) The ID of the Public IP Address."
  type        = string
}

variable "subnet_id" {
  description = "(Required) The ID of the Subnet."
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "(Optional) The ID of the Log Analytics Workspace."
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