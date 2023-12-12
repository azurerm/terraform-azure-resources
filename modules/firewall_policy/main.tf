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
      terraform-azurerm-module = "firewall_policy"
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

resource "azurerm_firewall_policy" "this" {
  name                              = coalesce(var.custom_name, module.naming.firewall_policy.name)
  location                          = var.location
  resource_group_name               = var.resource_group_name
  base_policy_id                    = var.base_policy_id
  private_ip_ranges                 = var.private_ip_ranges
  auto_learn_private_ranges_enabled = var.auto_learn_private_ranges_enabled
  sku                               = var.sku
  threat_intelligence_mode          = var.threat_intelligence_mode
  sql_redirect_allowed              = var.sql_redirect_allowed
  dns {
    proxy_enabled = var.dns_proxy_enabled
    servers       = var.dns_servers
  }

  tags = local.tags
}
