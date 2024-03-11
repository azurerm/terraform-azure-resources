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
      terraform-azurerm-module = "maintenance_configuration"
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

resource "azurerm_maintenance_configuration" "this" {
  name                     = coalesce(var.custom_name, module.naming.maintenance_configuration.name)
  resource_group_name      = var.resource_group_name
  location                 = var.location
  scope                    = var.scope
  in_guest_user_patch_mode = var.in_guest_user_patch_mode
  window {
    start_date_time      = var.window_start_date_time
    duration             = var.window_duration
    expiration_date_time = var.window_expiration_date_time
    time_zone            = var.window_time_zone
    recur_every          = var.window_recur_every
  }
  install_patches {
    linux {
      classifications_to_include    = var.linux_classifications_to_include
      package_names_mask_to_exclude = var.linux_package_names_mask_to_exclude
      package_names_mask_to_include = var.linux_package_names_mask_to_include
    }
    windows {
      classifications_to_include = var.windows_classifications_to_include
      kb_numbers_to_exclude      = var.windows_kb_numbers_to_exclude
      kb_numbers_to_include      = var.windows_kb_numbers_to_include
    }
    reboot = var.reboot
  }
  tags = local.tags
  lifecycle {
    ignore_changes = [
      window[0].start_date_time,
      install_patches[0].reboot
    ]
  }
}