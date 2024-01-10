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
      terraform-azurerm-module = "virtual_machine_extension"
    }
  )

  tags = merge(
    var.module_tags ? local.module_tags : {},
    var.workload != "" ? { workload = var.workload } : {},
    var.environment != "" ? { environment = var.environment } : {},
    var.tags
  )
}

resource "time_sleep" "wait" {
  create_duration = var.time_sleep
}

resource "azurerm_virtual_machine_extension" "this" {
  name                       = coalesce(var.custom_name, "${split("/", var.virtual_machine_id)[length(split("/", var.virtual_machine_id)) - 1]}-${var.type}")
  virtual_machine_id         = var.virtual_machine_id
  publisher                  = var.publisher
  type                       = var.type
  type_handler_version       = var.type_handler_version
  settings                   = var.settings
  automatic_upgrade_enabled  = var.automatic_upgrade_enabled
  auto_upgrade_minor_version = var.auto_upgrade_minor_version
  tags                       = local.tags

  depends_on = [
    time_sleep.wait
  ]
}
