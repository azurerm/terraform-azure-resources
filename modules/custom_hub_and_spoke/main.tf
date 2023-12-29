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
      terraform-azurerm-composable-level3 = "custom_hub_and_spoke"
    }
  )

  tags = merge(
    var.module_tags ? local.module_tags : {},
    var.tags
  )

  #dns_servers = var.dns_servers != null ? var.dns_servers : var.spoke_dns ? [module.spoke_dns[0].inbound_endpoint_ip] : []
  vnet_dns_servers = var.dns_servers != null ? var.dns_servers : var.firewall ? [module.hub.firewall_private_ip_address] : var.spoke_dns ? [module.spoke_dns[0].inbound_endpoint_ip] : []
  hub_dns_servers  = var.dns_servers != null ? var.dns_servers : var.spoke_dns ? [module.spoke_dns[0].inbound_endpoint_ip] : []
}

module "locations" {
  source   = "../locations"
  location = var.location
}

module "naming" {
  source = "../naming"
  suffix = [var.workload, var.environment, module.locations.short_name, var.instance]
}

module "hub" {
  source        = "../custom_hub"
  location      = var.location
  environment   = var.environment
  workload      = var.workload
  address_space = var.address_space_hub
  dns_servers   = local.hub_dns_servers
  firewall      = var.firewall
  gateway       = var.gateway
  bastion       = var.bastion
}

module "spoke" {
  source                  = "../custom_spoke"
  for_each                = { for spoke in var.address_space_spokes : "${spoke.workload}-${spoke.environment}-${spoke.instance}" => spoke }
  location                = var.location
  environment             = each.value.environment
  workload                = each.value.workload
  address_space           = each.value.address_space
  linux_virtual_machine   = each.value.virtual_machine
  windows_virtual_machine = each.value.virtual_machine
  dns_servers             = local.vnet_dns_servers
  firewall                = var.firewall
  default_next_hop        = var.firewall ? module.hub.firewall_private_ip_address : ""
}

module "virtual_network_peerings" {
  source                                = "../virtual_network_peerings"
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

module "route_to_spoke" {
  source                 = "../route"
  for_each               = (var.gateway && var.firewall) ? module.spoke : {}
  resource_group_name    = module.hub.resource_group_name
  route_table_name       = module.hub.route_table_name
  address_prefix         = each.value.address_space[0]
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = module.hub.firewall_private_ip_address
}

module "key_vault_secret" {
  source   = "../key_vault_secret"
  for_each = merge([for k, v in module.spoke : v.virtual_machines]...)
  name     = each.key
  value    = each.value.admin_password
  tags = {
    username = each.value.admin_username
    image    = each.value.source_image_reference_id
    ip       = each.value.private_ip_address
  }
  key_vault_id = module.hub.key_vault_id
}

module "spoke_dns" {
  source           = "../custom_spoke_dns"
  count            = (var.spoke_dns && var.address_space_spoke_dns != null) ? 1 : 0
  location         = var.location
  address_space    = var.address_space_spoke_dns
  firewall         = var.firewall
  default_next_hop = var.firewall ? module.hub.firewall_private_ip_address : null
}

module "virtual_network_peerings_dns" {
  source                                = "../virtual_network_peerings"
  count                                 = (var.spoke_dns && var.address_space_spoke_dns != null) ? 1 : 0
  virtual_network_1_resource_group_name = module.hub.resource_group_name
  virtual_network_1_id                  = module.hub.virtual_network_id
  virtual_network_1_hub                 = var.gateway
  virtual_network_2_resource_group_name = module.spoke_dns[0].resource_group_name
  virtual_network_2_id                  = module.spoke_dns[0].virtual_network_id

  depends_on = [
    module.hub,
    module.spoke_dns
  ]
}

module "route_to_spoke_dns" {
  source                 = "../route"
  count                  = (var.gateway && var.firewall && var.spoke_dns && var.address_space_spoke_dns != null) ? 1 : 0
  resource_group_name    = module.hub.resource_group_name
  route_table_name       = module.hub.route_table_name
  address_prefix         = module.spoke_dns[0].address_space[0]
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = module.hub.firewall_private_ip_address
}

module "spoke_jumphost" {
  source             = "../custom_spoke_jumphost"
  count              = (var.spoke_jumphost && var.address_space_spoke_jumphost != null) ? 1 : 0
  location           = var.location
  address_space      = var.address_space_spoke_jumphost
  dns_servers        = local.vnet_dns_servers
  default_next_hop   = var.firewall ? module.hub.firewall_private_ip_address : null
  firewall           = var.firewall
  firewall_policy_id = module.hub.firewall_policy_id
  firewall_public_ip = module.hub.firewall_public_ip_address
}

module "virtual_network_peerings_jumphost" {
  source                                = "../virtual_network_peerings"
  count                                 = (var.spoke_jumphost && var.address_space_spoke_jumphost != null) ? 1 : 0
  virtual_network_1_resource_group_name = module.hub.resource_group_name
  virtual_network_1_id                  = module.hub.virtual_network_id
  virtual_network_1_hub                 = var.gateway
  virtual_network_2_resource_group_name = module.spoke_jumphost[0].resource_group_name
  virtual_network_2_id                  = module.spoke_jumphost[0].virtual_network_id

  depends_on = [
    module.hub,
    module.spoke_jumphost
  ]
}

module "route_to_spoke_jumphost" {
  source                 = "../route"
  count                  = (var.gateway && var.firewall && var.spoke_jumphost && var.address_space_spoke_jumphost != null) ? 1 : 0
  resource_group_name    = module.hub.resource_group_name
  route_table_name       = module.hub.route_table_name
  address_prefix         = module.spoke_jumphost[0].address_space[0]
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = module.hub.firewall_private_ip_address
}

module "key_vault_secret_jumphost" {
  source   = "../key_vault_secret"
  for_each = merge([for k, v in module.spoke_jumphost : v.virtual_machines]...)
  name     = each.key
  value    = each.value.admin_password
  tags = {
    username = each.value.admin_username
    image    = each.value.source_image_reference_id
    ip       = each.value.private_ip_address
  }
  key_vault_id = module.hub.key_vault_id
}

module "spoke_dmz" {
  source                     = "../custom_spoke_dmz"
  count                      = (var.spoke_dmz && var.address_space_spoke_dmz != null) ? 1 : 0
  location                   = var.location
  address_space              = var.address_space_spoke_dmz
  dns_servers                = local.vnet_dns_servers
  web_application_firewall   = var.web_application_firewall
  firewall                   = var.firewall
  next_hop                   = var.firewall ? module.hub.firewall_private_ip_address : ""
  log_analytics_workspace_id = module.hub.log_analytics_workspace_id
}

module "virtual_network_peerings_dmz" {
  source                                = "../virtual_network_peerings"
  count                                 = (var.spoke_dmz && var.address_space_spoke_dmz != null) ? 1 : 0
  virtual_network_1_resource_group_name = module.hub.resource_group_name
  virtual_network_1_id                  = module.hub.virtual_network_id
  virtual_network_1_hub                 = var.gateway
  virtual_network_2_resource_group_name = module.spoke_dmz[0].resource_group_name
  virtual_network_2_id                  = module.spoke_dmz[0].virtual_network_id

  depends_on = [
    module.hub,
    module.spoke_dmz
  ]
}