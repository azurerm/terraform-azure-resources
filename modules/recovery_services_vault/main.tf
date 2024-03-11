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
      terraform-azurerm-module = "recovery_services_vault"
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

resource "azurerm_recovery_services_vault" "this" {
  name                         = coalesce(var.custom_name, module.naming.recovery_services_vault.name)
  location                     = var.location
  resource_group_name          = var.resource_group_name
  sku                          = var.sku
  immutability                 = var.immutability
  storage_mode_type            = var.storage_mode_type
  cross_region_restore_enabled = var.cross_region_restore_enabled
  soft_delete_enabled          = var.soft_delete_enabled
  tags                         = local.tags
}
