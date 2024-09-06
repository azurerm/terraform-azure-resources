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
      terraform-azurerm-composable-level2 = "pattern_monitoring"
    }
  )

  tags = merge(
    var.module_tags ? local.module_tags : {},
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

module "resource_group" {
  source      = "../resource_group"
  location    = var.location
  environment = var.environment
  workload    = var.workload
  instance    = var.instance
  tags        = local.tags
}

module "virtual_network" {
  source              = "../virtual_network"
  location            = var.location
  environment         = var.environment
  workload            = var.workload
  instance            = var.instance
  resource_group_name = module.resource_group.name
  address_space       = var.address_space
  dns_servers         = var.dns_servers
  tags                = local.tags
}

module "subnet" {
  source               = "../subnet"
  location             = var.location
  environment          = var.environment
  workload             = var.workload
  instance             = var.instance
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.virtual_network.name
  address_prefixes     = var.address_space
}

module "routing" {
  source              = "../pattern_routing"
  count               = var.firewall ? 1 : 0
  location            = var.location
  environment         = var.environment
  workload            = var.workload
  instance            = var.instance
  resource_group_name = module.resource_group.name
  next_hop            = var.next_hop
  subnet_id           = module.subnet.id
  tags                = local.tags
}

resource "azurerm_monitor_data_collection_rule" "this" {
  name                = module.naming.monitor_data_collection_rule.name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  destinations {
    log_analytics {
      name                  = "log_analytics"
      workspace_resource_id = var.log_analytics_workspace_id
    }
  }
  data_flow {
    streams      = ["Microsoft-Syslog", "Microsoft-Event", "Microsoft-InsightsMetrics", "Microsoft-ServiceMap"]
    destinations = ["log_analytics"]
  }
  data_sources {
    syslog {
      name    = "Syslog"
      streams = ["Microsoft-Syslog"]
      facility_names = [
        "*"
      ]
      log_levels = [
        "Debug",
        "Info",
        "Notice",
        "Warning",
        "Error",
        "Critical",
        "Alert",
        "Emergency",
      ]
    }
    windows_event_log {
      name = "EventLogs"
      streams = [
        "Microsoft-Event"
      ]
      x_path_queries = [
        "Application!*[System[(Level=1 or Level=2 or Level=3 or Level=4 or Level=0)]]",
        "Security!*[System[(band(Keywords,13510798882111488))]]",
        "System!*[System[(Level=1 or Level=2 or Level=3 or Level=4 or Level=0)]]",
      ]
    }
    performance_counter {
      counter_specifiers = [
        "\\VmInsights\\DetailedMetrics"
      ]
      name                          = "VMInsightsPerfCounters"
      sampling_frequency_in_seconds = 60
      streams                       = ["Microsoft-InsightsMetrics"]
    }
    extension {
      extension_name = "DependencyAgent"
      name           = "DependencyAgentDataSource"
      streams        = ["Microsoft-ServiceMap"]
    }
  }
}

resource "azurerm_monitor_data_collection_endpoint" "this" {
  name                          = module.naming.monitor_data_collection_endpoint.name
  resource_group_name           = module.resource_group.name
  location                      = module.resource_group.location
  public_network_access_enabled = false
}

resource "azurerm_monitor_private_link_scope" "this" {
  name                = module.naming.monitor_private_link_scope.name
  resource_group_name = module.resource_group.name
}

resource "azurerm_monitor_private_link_scoped_service" "law" {
  name                = "law-${module.naming.monitor_private_link_scoped_service.name}"
  resource_group_name = module.resource_group.name
  scope_name          = azurerm_monitor_private_link_scope.this.name
  linked_resource_id  = var.log_analytics_workspace_id
}

resource "azurerm_monitor_private_link_scoped_service" "mdce" {
  name                = "mdce-${module.naming.monitor_private_link_scoped_service.name}"
  resource_group_name = module.resource_group.name
  scope_name          = azurerm_monitor_private_link_scope.this.name
  linked_resource_id  = azurerm_monitor_data_collection_endpoint.this.id
}

resource "azurerm_private_endpoint" "this" {
  name                          = "${azurerm_monitor_private_link_scope.this.name}-pe"
  custom_network_interface_name = "${azurerm_monitor_private_link_scope.this.name}-nic"
  location                      = module.resource_group.location
  resource_group_name           = module.resource_group.name
  subnet_id                     = module.subnet.id

  private_service_connection {
    name                           = "psc-${azurerm_monitor_private_link_scope.this.name}"
    private_connection_resource_id = azurerm_monitor_private_link_scope.this.id
    subresource_names              = ["azuremonitor"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdzg-${azurerm_monitor_private_link_scope.this.name}"
    private_dns_zone_ids = var.private_dns_zone_ids
  }
}
