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

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Virtual Network."
  type        = string
}

variable "account_tier" {
  description = "(Optional) Defines the Tier to use for this storage account. Valid options are Standard and Premium."
  type        = string
  default     = "Standard"
}

variable "account_kind" {
  description = "(Optional) Defines the Kind to use for this storage account. Valid options are Storage, StorageV2, BlobStorage."
  type        = string
  default     = "StorageV2"
}

variable "account_replication_type" {
  description = "(Optional) Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS."
  type        = string
  default     = "LRS"
}

variable "https_traffic_only_enabled" {
  description = "(Optional) Allows https traffic only to storage service if set to true."
  type        = bool
  default     = true
}

variable "cross_tenant_replication_enabled" {
  description = "(Optional) Enable cross tenant replication for the storage account."
  type        = bool
  default     = false
}

variable "min_tls_version" {
  description = "(Optional) The minimum supported TLS version for the storage account. Valid values are TLS1_0, TLS1_1, and TLS1_2."
  type        = string
  default     = "TLS1_2"
}

variable "allow_nested_items_to_be_public" {
  description = "(Optional) Allow or disallow public access to items in the storage account that are not in a container."
  type        = bool
  default     = false
}

variable "shared_access_key_enabled" {
  description = "(Optional) Allow or disallow shared access signature (SAS) tokens to be created against the storage account."
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "(Optional) Allow or disallow public access to the storage account."
  type        = bool
  default     = true
}

variable "default_to_oauth_authentication" {
  description = "(Optional) Allow or disallow the use of OAuth 2.0 to authenticate with the storage account."
  type        = bool
  default     = false
}

variable "is_hns_enabled" {
  description = "(Optional) Enable or disable Hierarchical Namespace for the storage account."
  type        = bool
  default     = false
}

variable "nfsv3_enabled" {
  description = "(Optional) Enable or disable NFSv3 for the storage account."
  type        = bool
  default     = false
}

variable "network_rules_default_action" {
  description = "(Optional) The default action of allow or deny when no other rules match."
  type        = string
  default     = "Allow"
}

variable "network_rules_bypass" {
  description = "(Optional) Specifies whether traffic is bypassed for Logging/Metrics/AzureServices."
  type        = list(string)
  default     = []
}

variable "network_rules_ip_rules" {
  description = "(Optional) List of public IP or IP ranges in CIDR format to allow traffic from. Only IPV4 addresses are allowed."
  type        = list(string)
  default     = []
}

variable "network_rules_virtual_network_subnet_ids" {
  description = "(Optional) List of Virtual Network Subnet IDs to allow traffic from."
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
