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

  virtual_machines = merge([for k, v in module.spoke : v.virtual_machines]...)

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
  firewall_sku  = var.firewall_sku
  gateway       = var.gateway
  gateway_type  = var.gateway_type
  gateway_sku   = var.gateway_sku
  bastion       = var.bastion
  bastion_sku   = var.bastion_sku
  tags          = local.tags
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
  monitor_agent           = var.private_monitoring
  watcher_agent           = var.connection_monitor
  firewall                = var.firewall
  next_hop                = var.firewall ? module.hub.firewall_private_ip_address : ""
  tags                    = local.tags
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
  tags             = local.tags
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
  tags               = local.tags
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
  tags                       = local.tags
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

module "custom_monitoring" {
  source                     = "../custom_monitoring"
  count                      = (var.private_monitoring && var.address_space_spoke_private_monitoring != null) ? 1 : 0
  location                   = var.location
  address_space              = var.address_space_spoke_private_monitoring
  dns_servers                = local.vnet_dns_servers
  firewall                   = var.firewall
  next_hop                   = var.firewall ? module.hub.firewall_private_ip_address : ""
  log_analytics_workspace_id = module.hub.log_analytics_workspace_id
  private_dns_zone_ids = [
    module.spoke_dns[0].private_dns_zones["privatelink.monitor.azure.com"]["id"],
    module.spoke_dns[0].private_dns_zones["privatelink.agentsvc.azure-automation.net"]["id"],
    module.spoke_dns[0].private_dns_zones["privatelink.ods.opinsights.azure.com"]["id"],
    module.spoke_dns[0].private_dns_zones["privatelink.oms.opinsights.azure.com"]["id"],
    module.spoke_dns[0].private_dns_zones["privatelink.blob.core.windows.net"]["id"],
  ]
  tags = local.tags
}

module "virtual_network_peerings_monitoring" {
  source                                = "../virtual_network_peerings"
  count                                 = (var.private_monitoring && var.address_space_spoke_private_monitoring != null) ? 1 : 0
  virtual_network_1_resource_group_name = module.hub.resource_group_name
  virtual_network_1_id                  = module.hub.virtual_network_id
  virtual_network_1_hub                 = var.gateway
  virtual_network_2_resource_group_name = module.custom_monitoring[0].resource_group_name
  virtual_network_2_id                  = module.custom_monitoring[0].virtual_network_id

  depends_on = [
    module.hub,
    module.custom_monitoring
  ]
}

module "data_collection_rule_association" {
  source                  = "../monitor_data_collection_rule_association"
  for_each                = var.private_monitoring ? merge([for k, v in module.spoke : v.virtual_machines]...) : {}
  name                    = "${each.key}-dcra"
  target_resource_id      = each.value.id
  data_collection_rule_id = module.custom_monitoring[0].monitor_data_collection_rule_id
}

module "data_collection_endpoint_association" {
  source                      = "../monitor_data_collection_rule_association"
  for_each                    = var.private_monitoring ? merge([for k, v in module.spoke : v.virtual_machines]...) : {}
  target_resource_id          = each.value.id
  data_collection_endpoint_id = module.custom_monitoring[0].monitor_data_collection_endpoint_id
}

data "azurerm_network_watcher" "this" {
  name                = "NetworkWatcher_${var.location}"
  resource_group_name = "NetworkWatcherRG"
}

resource "azurerm_network_connection_monitor" "exxternal" {
  for_each           = var.connection_monitor ? merge([for k, v in module.spoke : v.virtual_machines]...) : {}
  name               = "Monitor-Internet-${each.key}"
  network_watcher_id = data.azurerm_network_watcher.this.id
  location           = data.azurerm_network_watcher.this.location

  endpoint {
    name               = each.key
    target_resource_id = each.value.id
  }

  endpoint {
    name    = "terraform-io"
    address = "terraform.io"
  }

  endpoint {
    name    = "ifconfig-me"
    address = "ifconfig.me"
  }

  test_configuration {
    name                      = "HttpTestConfiguration"
    protocol                  = "Http"
    test_frequency_in_seconds = 60

    http_configuration {
      port                     = 80
      valid_status_code_ranges = ["200-399"]
    }
  }

  test_configuration {
    name                      = "TCP443TestConfiguration"
    protocol                  = "Tcp"
    test_frequency_in_seconds = 60

    tcp_configuration {
      port = 443
    }
  }

  test_group {
    name                     = "Monitor-Internet-${each.key}"
    destination_endpoints    = ["ifconfig-me", "terraform-io"]
    source_endpoints         = [each.key]
    test_configuration_names = ["HttpTestConfiguration", "TCP443TestConfiguration"]
  }

  output_workspace_resource_ids = [module.hub.log_analytics_workspace_id]
}


resource "azurerm_network_connection_monitor" "internal" {
  count              = var.connection_monitor ? 1 : 0
  name               = "Monitor-Private"
  network_watcher_id = data.azurerm_network_watcher.this.id
  location           = data.azurerm_network_watcher.this.location

  dynamic "endpoint" {
    for_each = local.virtual_machines
    content {
      name               = endpoint.key
      target_resource_id = endpoint.value.id
    }
  }

  test_configuration {
    name                      = "IcmpTestConfiguration"
    protocol                  = "Icmp"
    test_frequency_in_seconds = 60
  }

  test_group {
    name                     = "Monitor-Private"
    destination_endpoints    = [for k, v in local.virtual_machines : k]
    source_endpoints         = [for k, v in local.virtual_machines : k]
    test_configuration_names = ["IcmpTestConfiguration"]
  }

  output_workspace_resource_ids = [module.hub.log_analytics_workspace_id]
}