terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

locals {
  module_tags = tomap(
    {
      terraform-azurerm-module = "log_analytics_workspace"
    }
  )

  tags = merge(
    var.module_tags ? local.module_tags : {},
    var.workload != "" ? { workload = var.workload } : {},
    var.environment != "" ? { environment = var.environment } : {},
    var.tags
  )
}

module "locations" {
  source   = "../locations"
  location = var.location
}

module "naming" {
  source = "../naming"
  suffix = [var.workload, var.environment, module.locations.short_name, var.instance]
}

resource "azurerm_log_analytics_workspace" "this" {
  name                            = coalesce(var.custom_name, module.naming.log_analytics_workspace.name)
  location                        = var.location
  resource_group_name             = var.resource_group_name
  sku                             = var.sku
  retention_in_days               = var.retention_in_days
  allow_resource_only_permissions = var.allow_resource_only_permissions
  local_authentication_enabled    = var.local_authentication_enabled
  daily_quota_gb                  = var.daily_quota_gb
  internet_ingestion_enabled      = var.internet_ingestion_enabled
  internet_query_enabled          = var.internet_query_enabled
  #reservation_capacity_in_gb_per_day = var.reservation_capacity_in_gb_per_day
  tags = local.tags
}