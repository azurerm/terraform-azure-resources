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
      terraform-azurerm-module = "ai_services"
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
  location = contains(var.deployment_availability, var.location) ? var.location : var.default_location
}

module "naming" {
  source = "../naming"
  suffix = [var.workload, var.environment, module.locations.short_name, var.instance]
}

resource "random_integer" "this" {
  min = 1000
  max = 9999
}

resource "azurerm_ai_services" "this" {
  name                               = coalesce(var.custom_name, module.naming.ai_services.name)
  location                           = contains(var.deployment_availability, var.location) ? var.location : var.default_location
  resource_group_name                = var.resource_group_name
  sku_name                           = var.sku_name
  custom_subdomain_name              = "azure-ai-services-${random_integer.this.result}"
  fqdns                              = var.fqdns
  local_authentication_enabled       = var.local_authentication_enabled
  outbound_network_access_restricted = var.outbound_network_access_restricted
  public_network_access              = var.public_network_access

  dynamic "identity" {
    for_each = var.identity
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "network_acls" {
    for_each = var.network_acls
    content {
      default_action = network_acls.value.default_action
      ip_rules       = network_acls.value.ip_rules
    }
  }

  tags = local.tags
}

