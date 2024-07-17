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
      terraform-azurerm-module = "virtual_network_gateway_connection",
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
  suffix = [var.workload, var.environment, var.instance]
}

resource "azurerm_virtual_network_gateway_connection" "this" {
  name                       = coalesce(var.custom_name, module.naming.virtual_network_gateway_connection.name)
  location                   = var.location
  resource_group_name        = var.resource_group_name
  type                       = var.type
  virtual_network_gateway_id = var.virtual_network_gateway_id
  local_network_gateway_id   = var.local_network_gateway_id
  shared_key                 = var.shared_key
  connection_mode            = var.connection_mode
  routing_weight             = var.routing_weight
  connection_protocol        = var.connection_protocol
  enable_bgp                 = var.enable_bgp
  tags                       = local.tags
}
