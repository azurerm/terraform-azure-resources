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
      terraform-azurerm-module = "virtual_network_gateway"
    }
  )

  tags = merge(
    var.module_tags ? local.module_tags : {},
    var.workload != "" ? { workload = var.workload } : {},
    var.environment != "" ? { environment = var.environment } : {},
    var.tags
  )
}

data "azurerm_client_config" "current" {}

module "locations" {
  source   = "../locations"
  location = var.location
}

module "naming" {
  source = "../naming"
  suffix = [var.workload, var.environment, module.locations.short_name, var.instance]
}

resource "random_integer" "this" {
  min = 64512
  max = 65514
}

resource "azurerm_virtual_network_gateway" "this" {
  name                = coalesce(var.custom_name, module.naming.virtual_network_gateway.name)
  location            = var.location
  resource_group_name = var.resource_group_name
  type                = var.type
  vpn_type            = var.vpn_type
  active_active       = var.active_active
  enable_bgp          = var.enable_bgp
  sku                 = var.sku

  dynamic "bgp_settings" {
    for_each = var.enable_bgp ? [1] : []
    content {
      asn = var.asn == 0 ? random_integer.this.result : var.asn
    }
  }

  dynamic "ip_configuration" {
    for_each = var.ip_configurations
    content {
      name                          = ip_configuration.value.name
      public_ip_address_id          = ip_configuration.value.public_ip_address_id
      private_ip_address_allocation = ip_configuration.value.private_ip_address_allocation
      subnet_id                     = ip_configuration.value.subnet_id
    }
  }

  dynamic "vpn_client_configuration" {
    for_each = var.p2s_vpn ? [1] : []
    content {
      aad_audience  = "41b23e61-6c1e-4545-b367-cd054e0ed4b4"
      aad_issuer    = "https://sts.windows.net/${data.azurerm_client_config.current.tenant_id}/"
      aad_tenant    = "https://login.microsoftonline.com/${data.azurerm_client_config.current.tenant_id}"
      address_space = var.address_space
      vpn_auth_types = [
        "AAD"
      ]
      vpn_client_protocols = [
        "OpenVPN"
      ]
    }
  }

  tags = local.tags
}
