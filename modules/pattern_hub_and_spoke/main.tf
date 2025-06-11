terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    restapi = {
      source = "mastercard/restapi"
    }
  }
}

locals {
  module_tags = tomap(
    {
      terraform-azurerm-composable-level3 = "pattern_hub_and_spoke"
    }
  )

  tags = merge(
    var.module_tags ? local.module_tags : {},
    var.tags
  )

  virtual_machines = merge([for k, v in module.spoke : v.virtual_machines]...)

  #dns_servers = var.dns_servers != null ? var.dns_servers : var.spoke_dns ? [module.spoke_dns[0].inbound_endpoint_ip] : []
  vnet_dns_servers = var.dns_servers != null ? var.dns_servers : var.firewall ? [module.hub.firewall_private_ip_address] : var.spoke_dns ? [module.spoke_dns[0].inbound_endpoint_ip] : []
  hub_dns_servers  = var.dns_servers != null ? var.dns_servers : (var.spoke_dns && !var.firewall_palo_alto) ? [module.spoke_dns[0].inbound_endpoint_ip] : []
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
  source                              = "../pattern_hub"
  location                            = var.location
  environment                         = var.environment
  workload                            = var.workload
  address_space                       = var.address_space_hub
  dns_servers                         = local.hub_dns_servers
  firewall                            = var.firewall
  firewall_sku                        = var.firewall_sku
  firewall_palo_alto                  = var.firewall_palo_alto
  gateway                             = var.gateway
  gateway_type                        = var.gateway_type
  gateway_sku                         = var.gateway_sku
  p2s_vpn                             = var.p2s_vpn
  bastion                             = var.bastion
  bastion_sku                         = var.bastion_sku
  key_vault                           = var.key_vault
  storage_account                     = var.network_security_group
  ip_filter                           = var.ip_filter
  additional_access_policy_object_ids = var.additional_access_policy_object_ids
  tags                                = local.tags
}

module "key_vault_palo_alto_secret" {
  source = "../key_vault_secret"
  count  = var.firewall_palo_alto ? 1 : 0
  name   = "fw-hub-prd-${module.locations.short_name}"
  value  = module.hub.palo_alto_password
  tags = {
    username = "panadmin"
    image    = "PAN-OS"
  }
  key_vault_id = module.hub.key_vault_id
}

module "spoke" {
  source                  = "../pattern_spoke"
  for_each                = { for spoke in var.address_space_spokes : "${spoke.workload}-${spoke.environment}-${spoke.instance}" => spoke }
  location                = var.location
  environment             = each.value.environment
  workload                = each.value.workload
  address_space           = each.value.address_space
  linux_virtual_machine   = each.value.virtual_machines
  windows_virtual_machine = each.value.virtual_machines
  dns_servers             = local.vnet_dns_servers
  monitor_agent           = var.private_monitoring
  watcher_agent           = var.connection_monitor
  update_management       = var.update_management
  network_security_group  = var.network_security_group
  firewall                = (var.firewall || var.firewall_palo_alto)
  next_hop                = (var.firewall || var.firewall_palo_alto) ? module.hub.firewall_private_ip_address : ""
  single_route_table      = var.spokes_single_route_table
  route_table_id          = var.spokes_single_route_table ? module.spokes_single_route_table[0].id : ""
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

module "spokes_single_route_table" {
  source                        = "../route_table"
  count                         = var.spokes_single_route_table ? 1 : 0
  location                      = var.location
  environment                   = var.environment
  workload                      = "spokes"
  instance                      = var.instance
  resource_group_name           = module.hub.resource_group_name
  bgp_route_propagation_enabled = false
  tags                          = local.tags
}

module "spokes_default_route" {
  source                 = "../route"
  count                  = var.spokes_single_route_table ? 1 : 0
  resource_group_name    = module.hub.resource_group_name
  route_table_name       = module.spokes_single_route_table[0].name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = module.hub.firewall_private_ip_address
}

module "route_to_spoke" {
  source                 = "../route"
  for_each               = (var.gateway && (var.firewall || var.firewall_palo_alto)) ? module.spoke : {}
  resource_group_name    = module.hub.resource_group_name
  route_table_name       = module.hub.route_table_name
  address_prefix         = each.value.address_space[0]
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = module.hub.firewall_private_ip_address
}

module "key_vault_secret" {
  source   = "../key_vault_secret"
  for_each = var.key_vault ? merge([for k, v in module.spoke : v.virtual_machines]...) : {}
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
  source           = "../pattern_spoke_dns"
  count            = (var.spoke_dns && var.address_space_spoke_dns != null) ? 1 : 0
  location         = var.location
  address_space    = var.address_space_spoke_dns
  firewall         = (var.firewall || var.firewall_palo_alto)
  default_next_hop = (var.firewall || var.firewall_palo_alto) ? module.hub.firewall_private_ip_address : null
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
  count                  = (var.gateway && (var.firewall || var.firewall_palo_alto) && var.spoke_dns && var.address_space_spoke_dns != null) ? 1 : 0
  resource_group_name    = module.hub.resource_group_name
  route_table_name       = module.hub.route_table_name
  address_prefix         = module.spoke_dns[0].address_space[0]
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = module.hub.firewall_private_ip_address
}

module "spoke_jumphost" {
  source             = "../pattern_spoke_jumphost"
  count              = (var.spoke_jumphost && var.address_space_spoke_jumphost != null) ? 1 : 0
  location           = var.location
  address_space      = var.address_space_spoke_jumphost
  dns_servers        = local.vnet_dns_servers
  default_next_hop   = (var.firewall || var.firewall_palo_alto) ? module.hub.firewall_private_ip_address : null
  firewall           = (var.firewall || var.firewall_palo_alto)
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
  count                  = (var.gateway && (var.firewall || var.firewall_palo_alto) && var.spoke_jumphost && var.address_space_spoke_jumphost != null) ? 1 : 0
  resource_group_name    = module.hub.resource_group_name
  route_table_name       = module.hub.route_table_name
  address_prefix         = module.spoke_jumphost[0].address_space[0]
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = module.hub.firewall_private_ip_address
}

module "key_vault_secret_jumphost" {
  source   = "../key_vault_secret"
  for_each = var.key_vault ? merge([for k, v in module.spoke_jumphost : v.virtual_machines]...) : {}
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
  source                     = "../pattern_spoke_dmz"
  count                      = (var.spoke_dmz && var.address_space_spoke_dmz != null) ? 1 : 0
  location                   = var.location
  address_space              = var.address_space_spoke_dmz
  dns_servers                = local.vnet_dns_servers
  web_application_firewall   = var.web_application_firewall
  firewall                   = (var.firewall || var.firewall_palo_alto)
  next_hop                   = (var.firewall || var.firewall_palo_alto) ? module.hub.firewall_private_ip_address : ""
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

module "spoke_ai" {
  source        = "../pattern_spoke_ai"
  count         = (var.spoke_ai && var.address_space_spoke_ai != null) ? 1 : 0
  location      = var.location
  address_space = var.address_space_spoke_ai
  dns_servers   = local.vnet_dns_servers
  ip_filter     = var.ip_filter
  private_paas  = var.private_paas
  firewall      = var.firewall
  next_hop      = var.firewall ? module.hub.firewall_private_ip_address : ""
  private_dns_zone_ids = [
    module.spoke_dns[0].private_dns_zones["privatelink.cognitiveservices.azure.com"]["id"],
    module.spoke_dns[0].private_dns_zones["privatelink.openai.azure.com"]["id"],
    module.spoke_dns[0].private_dns_zones["privatelink.azurewebsites.net"]["id"],
    module.spoke_dns[0].private_dns_zones["privatelink.blob.core.windows.net"]["id"],
    module.spoke_dns[0].private_dns_zones["privatelink.search.windows.net"]["id"],
  ]
  log_analytics_workspace_id = module.hub.log_analytics_workspace_id
  tags                       = local.tags
}

module "virtual_network_peerings_ai" {
  source                                = "../virtual_network_peerings"
  count                                 = (var.spoke_ai && var.address_space_spoke_ai != null) ? 1 : 0
  virtual_network_1_resource_group_name = module.hub.resource_group_name
  virtual_network_1_id                  = module.hub.virtual_network_id
  virtual_network_1_hub                 = var.gateway
  virtual_network_2_resource_group_name = module.spoke_ai[0].resource_group_name
  virtual_network_2_id                  = module.spoke_ai[0].virtual_network_id

  depends_on = [
    module.hub,
    module.spoke_ai
  ]
}

provider "restapi" {
  uri                  = (var.spoke_ai && var.address_space_spoke_ai != null) ? "https://${module.spoke_ai[0].search_service_name}.search.windows.net" : "https://management.azure.com"
  write_returns_object = true
  debug                = false

  headers = {
    "api-key"      = (var.spoke_ai && var.address_space_spoke_ai != null) ? module.spoke_ai[0].search_service_key : "",
    "Content-Type" = "application/json"
  }

  create_method  = "POST"
  update_method  = "PUT"
  destroy_method = "DELETE"
}

resource "restapi_object" "create_index" {
  count        = (var.spoke_ai && var.address_space_spoke_ai != null) ? 1 : 0
  path         = "/indexes"
  query_string = "api-version=2024-05-01-preview"
  data         = templatefile("${path.module}/../pattern_spoke_ai/config/index.json", { search_service_name = module.spoke_ai[0].search_service_name })
  id_attribute = "name" # The ID field on the response
  depends_on = [
    module.spoke_ai[0]
  ]
}

resource "restapi_object" "create_datasource" {
  count        = (var.spoke_ai && var.address_space_spoke_ai != null) ? 1 : 0
  path         = "/datasources"
  query_string = "api-version=2024-05-01-preview"
  data         = templatefile("${path.module}/../pattern_spoke_ai/config/data-source.json", { search_service_name = module.spoke_ai[0].search_service_name, storage_account_id = module.spoke_ai[0].storage_account_id, container_name = module.spoke_ai[0].container_name })
  id_attribute = "name" # The ID field on the response
  depends_on = [
    module.spoke_ai[0]
  ]
}

resource "restapi_object" "create_indexer" {
  count        = (var.spoke_ai && var.address_space_spoke_ai != null) ? 1 : 0
  path         = "/indexers"
  query_string = "api-version=2024-05-01-preview"
  data         = templatefile("${path.module}/../pattern_spoke_ai/config/indexer.json", { search_service_name = module.spoke_ai[0].search_service_name, container_name = module.spoke_ai[0].container_name })
  id_attribute = "name" # The ID field on the response
  depends_on = [
    restapi_object.create_index[0],
    restapi_object.create_datasource[0],
  ]
}

module "route_to_spoke_dmz" {
  source                 = "../route"
  count                  = (var.gateway && var.firewall && var.spoke_dmz && var.address_space_spoke_dmz != null) ? 1 : 0
  resource_group_name    = module.hub.resource_group_name
  route_table_name       = module.hub.route_table_name
  address_prefix         = module.spoke_dmz[0].address_space[0]
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = module.hub.firewall_private_ip_address
}

module "pattern_monitoring" {
  source                     = "../pattern_monitoring"
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
    module.spoke_dns[0].private_dns_zones["privatelink.blob.core.windows.net"]["id"]
  ]
  tags = local.tags
}

module "virtual_network_peerings_monitoring" {
  source                                = "../virtual_network_peerings"
  count                                 = (var.private_monitoring && var.address_space_spoke_private_monitoring != null) ? 1 : 0
  virtual_network_1_resource_group_name = module.hub.resource_group_name
  virtual_network_1_id                  = module.hub.virtual_network_id
  virtual_network_1_hub                 = var.gateway
  virtual_network_2_resource_group_name = module.pattern_monitoring[0].resource_group_name
  virtual_network_2_id                  = module.pattern_monitoring[0].virtual_network_id

  depends_on = [
    module.hub,
    module.pattern_monitoring
  ]
}

module "data_collection_rule_association" {
  source                  = "../monitor_data_collection_rule_association"
  for_each                = var.private_monitoring ? merge([for k, v in module.spoke : v.virtual_machines]...) : {}
  name                    = "${each.key}-dcra"
  target_resource_id      = each.value.id
  data_collection_rule_id = module.pattern_monitoring[0].monitor_data_collection_rule_id
}

module "data_collection_endpoint_association" {
  source                      = "../monitor_data_collection_rule_association"
  for_each                    = var.private_monitoring ? merge([for k, v in module.spoke : v.virtual_machines]...) : {}
  target_resource_id          = each.value.id
  data_collection_endpoint_id = module.pattern_monitoring[0].monitor_data_collection_endpoint_id
}

data "azurerm_network_watcher" "this" {
  name                = "NetworkWatcher_${var.location}"
  resource_group_name = "NetworkWatcherRG"
}

resource "azurerm_network_connection_monitor" "external" {
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

resource "azurerm_network_watcher_flow_log" "this" {
  for_each             = var.network_security_group ? module.spoke : {}
  network_watcher_name = data.azurerm_network_watcher.this.name
  resource_group_name  = data.azurerm_network_watcher.this.resource_group_name
  name                 = "vnet-flowlog-${each.key}"

  target_resource_id = each.value.virtual_network_id
  storage_account_id = module.hub.storage_account_id
  enabled            = true
  version            = 2

  retention_policy {
    enabled = true
    days    = 7
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = module.hub.log_analytics_workspace_workspace_id
    workspace_region      = var.location
    workspace_resource_id = module.hub.log_analytics_workspace_id
    interval_in_minutes   = 10
  }
}

resource "azurerm_network_watcher_flow_log" "hub" {
  count                = var.network_security_group ? 1 : 0
  network_watcher_name = data.azurerm_network_watcher.this.name
  resource_group_name  = data.azurerm_network_watcher.this.resource_group_name
  name                 = "vnet-flowlog-${module.hub.virtual_network_name}"

  target_resource_id = module.hub.virtual_network_id
  storage_account_id = module.hub.storage_account_id
  enabled            = true
  version            = 2

  retention_policy {
    enabled = true
    days    = 7
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = module.hub.log_analytics_workspace_workspace_id
    workspace_region      = var.location
    workspace_resource_id = module.hub.log_analytics_workspace_id
    interval_in_minutes   = 10
  }
}

module "recovery_services_vault" {
  source              = "../recovery_services_vault"
  count               = var.backup ? 1 : 0
  location            = var.location
  environment         = var.environment
  workload            = var.workload_management
  instance            = var.instance
  resource_group_name = module.hub.resource_group_management_name
  tags                = local.tags
}

module "backup_policy_vm_production" {
  source                = "../backup_policy_vm"
  count                 = var.backup ? 1 : 0
  location              = var.location
  environment           = "prd"
  workload              = var.workload_management
  instance              = var.instance
  resource_group_name   = module.hub.resource_group_management_name
  recovery_vault_name   = module.recovery_services_vault[0].name
  retention_daily_count = 14
}

module "backup_policy_vm_development" {
  source                = "../backup_policy_vm"
  count                 = var.backup ? 1 : 0
  location              = var.location
  environment           = "dev"
  workload              = var.workload_management
  instance              = var.instance
  resource_group_name   = module.hub.resource_group_management_name
  recovery_vault_name   = module.recovery_services_vault[0].name
  retention_daily_count = 7
}

resource "azurerm_backup_protected_vm" "this" {
  for_each            = var.backup ? local.virtual_machines : {}
  resource_group_name = module.hub.resource_group_management_name
  recovery_vault_name = module.recovery_services_vault[0].name
  source_vm_id        = each.value.id
  backup_policy_id    = strcontains(each.value.id, "prd") ? module.backup_policy_vm_production[0].id : module.backup_policy_vm_development[0].id
}