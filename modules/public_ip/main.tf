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
      terraform-module-source = "azurerm/resources/azure//modules/public_ip"
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

resource "azurerm_public_ip" "this" {
  name                = coalesce(var.custom_name, module.naming.public_ip.name)
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.allocation_method
  sku                 = var.sku
  sku_tier            = var.sku_tier
  zones               = var.zones
  domain_name_label   = var.domain_name_label
  tags                = local.tags
}
