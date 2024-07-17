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
      terraform-azurerm-module = "local_network_gateway",
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

resource "azurerm_local_network_gateway" "this" {
  name                = coalesce(var.custom_name, module.naming.local_network_gateway.name)
  location            = var.location
  resource_group_name = var.resource_group_name
  gateway_address     = var.gateway_address
  gateway_fqdn        = var.gateway_fqdn
  address_space       = var.address_space
  dynamic "bgp_settings" {
    for_each = var.asn != "" ? [1] : []
    content {
      asn                 = var.asn
      bgp_peering_address = var.bgp_peering_address
      peer_weight         = var.peer_weight
    }
  }
  tags = local.tags
}
