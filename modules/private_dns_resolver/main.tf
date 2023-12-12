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
      terraform-azurerm-module = "private_dns_resolver"
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

resource "azurerm_private_dns_resolver" "this" {
  name                = coalesce(var.custom_name, module.naming.private_dns_resolver.name)
  location            = var.location
  resource_group_name = var.resource_group_name
  virtual_network_id  = var.virtual_network_id
  tags                = local.tags
}

resource "azurerm_private_dns_resolver_inbound_endpoint" "this" {
  name                    = coalesce(var.custom_name_inbound_endpoint, module.naming.private_dns_resolver_inbound.name)
  private_dns_resolver_id = azurerm_private_dns_resolver.this.id
  location                = azurerm_private_dns_resolver.this.location
  ip_configurations {
    private_ip_allocation_method = "Dynamic"
    subnet_id                    = var.inbound_endpoint_subnet_id
  }
  tags = local.tags
}

resource "azurerm_private_dns_resolver_outbound_endpoint" "this" {
  name                    = coalesce(var.custom_name_outbound_endpoint, module.naming.private_dns_resolver_outbound.name)
  private_dns_resolver_id = azurerm_private_dns_resolver.this.id
  location                = azurerm_private_dns_resolver.this.location
  subnet_id               = var.outbound_endpoint_subnet_id
  tags                    = local.tags
}
