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
      terraform-module-composable = "azurerm/resources/azure//modules/custom_hub_and_spoke"
    }
  )

  tags = merge(
    var.module_tags ? local.module_tags : {},
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

module "hub" {
  source        = "azurerm/resources/azure//modules/custom_hub"
  location      = var.location
  environment   = var.environment
  workload      = var.workload
  address_space = var.address_space_hub
  dns_servers   = var.dns_servers
  firewall      = var.firewall
  gateway       = var.gateway
}

module "spoke" {
  source        = "azurerm/resources/azure//modules/custom_spoke"
  for_each      = { for spoke in var.address_space_spoke : "${spoke.workload}-${spoke.environment}-${spoke.instance}" => spoke }
  location      = var.location
  environment   = each.value.environment
  workload      = each.value.workload
  address_space = each.value.address_space
  dns_servers   = var.dns_servers
}

module "virtual_network_peerings" {
  source                                = "azurerm/resources/azure//modules/virtual_network_peerings"
  for_each                              = module.spoke
  virtual_network_1_resource_group_name = module.hub.resource_group_name
  virtual_network_1_id                  = module.hub.virtual_network_id
  virtual_network_1_hub                 = var.gateway
  virtual_network_2_resource_group_name = each.value.resource_group_name
  virtual_network_2_id                  = each.value.virtual_network_id

  depends_on = [
    module.hub,
    module.spoke
  ]
}

module "spoke_dns" {
  source        = "azurerm/resources/azure//modules/custom_spoke_dns"
  count         = var.spoke_dns ? 1 : 0
  location      = var.location
  address_space = var.address_space_spoke_dns
}

module "virtual_network_peerings_dns" {
  source                                = "azurerm/resources/azure//modules/virtual_network_peerings"
  count                                 = var.spoke_dns ? 1 : 0
  virtual_network_1_resource_group_name = module.hub.resource_group_name
  virtual_network_1_id                  = module.hub.virtual_network_id
  virtual_network_1_hub                 = var.gateway
  virtual_network_2_resource_group_name = var.spoke_dns.resource_group_name
  virtual_network_2_id                  = var.spoke_dns.virtual_network_id

  depends_on = [
    module.hub,
    module.spoke_dns
  ]
}
