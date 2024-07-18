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
      terraform-azurerm-module = "bastion_host"
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

resource "azurerm_bastion_host" "this" {
  name                   = coalesce(var.custom_name, module.naming.bastion_host.name)
  location               = var.location
  resource_group_name    = var.resource_group_name
  sku                    = var.sku
  copy_paste_enabled     = var.copy_paste_enabled
  file_copy_enabled      = var.file_copy_enabled
  ip_connect_enabled     = var.ip_connect_enabled
  scale_units            = var.scale_units
  shareable_link_enabled = var.shareable_link_enabled
  tunneling_enabled      = var.tunneling_enabled
  virtual_network_id     = var.virtual_network_id
  dynamic "ip_configuration" {
    for_each = var.sku != "Developer" ? [1] : []
    content {
      name                 = var.ip_configuration_name
      subnet_id            = var.subnet_id
      public_ip_address_id = var.public_ip_address_id
    }
  }
  tags = local.tags
}
