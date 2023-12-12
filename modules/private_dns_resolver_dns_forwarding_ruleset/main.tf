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
      terraform-azurerm-module = "private_dns_resolver_dns_forwarding_ruleset"
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

resource "azurerm_private_dns_resolver_dns_forwarding_ruleset" "this" {
  name                                       = coalesce(var.custom_name, module.naming.private_dns_resolver_ruleset.name)
  location                                   = var.location
  resource_group_name                        = var.resource_group_name
  private_dns_resolver_outbound_endpoint_ids = var.private_dns_resolver_outbound_endpoint_ids
  tags                                       = local.tags
}

resource "azurerm_private_dns_resolver_virtual_network_link" "this" {
  name                      = coalesce(var.custom_name_link, module.naming.private_dns_resolver_network_link.name)
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.this.id
  virtual_network_id        = var.virtual_network_id
}
