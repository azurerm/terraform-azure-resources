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
      terraform-module-source = "azurerm/resources/azure//modules/resource_group"
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
  source   = "azurerm/locations/azure"
  location = var.location
}

module "naming" {
  source = "azurerm/naming/azure"
  suffix = [var.workload, var.environment, module.locations.short_name, var.instance]
}

resource "azurerm_resource_group" "this" {
  name     = coalesce(var.custom_name, module.naming.resource_group.name)
  location = var.location

  tags = local.tags
}