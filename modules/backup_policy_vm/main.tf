terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

module "locations" {
  source   = "../locations"
  location = var.location
}

module "naming" {
  source = "../naming"
  suffix = [var.workload, var.environment, module.locations.short_name, var.instance]
}

resource "azurerm_backup_policy_vm" "this" {
  name                           = coalesce(var.custom_name, module.naming.backup_policy_vm.name)
  resource_group_name            = var.resource_group_name
  recovery_vault_name            = var.recovery_vault_name
  timezone                       = var.timezone
  instant_restore_retention_days = var.instant_restore_retention_days

  backup {
    frequency = var.backup_frequency
    time      = var.backup_time
  }

  retention_daily {
    count = var.retention_daily_count
  }
}
