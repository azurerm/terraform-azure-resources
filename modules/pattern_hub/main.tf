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
      terraform-azurerm-composable-level2 = "pattern_hub"
    }
  )

  tags = merge(
    var.module_tags ? local.module_tags : {},
    var.tags
  )
}

data "azurerm_client_config" "current" {}

data "http" "ipinfo" {
  count = var.key_vault ? 1 : 0
  url   = "https://ifconfig.me"
  #data.http.ipinfo[0].response_body
}

module "resource_group" {
  source      = "../resource_group"
  location    = var.location
  environment = var.environment
  workload    = var.workload
  instance    = var.instance
  tags        = local.tags
}

module "resource_group_management" {
  source      = "../resource_group"
  location    = var.location
  environment = var.environment
  workload    = var.workload_management
  instance    = var.instance
  tags        = local.tags
}

module "log_analytics_workspace" {
  source              = "../log_analytics_workspace"
  location            = var.location
  environment         = var.environment
  workload            = var.workload_management
  instance            = var.instance
  resource_group_name = module.resource_group_management.name
  tags                = local.tags
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

module "subnet_gateway" {
  source               = "../subnet"
  count                = var.gateway ? 1 : 0
  location             = var.location
  custom_name          = "GatewaySubnet"
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.virtual_network.name
  address_prefixes     = [cidrsubnet(var.address_space[0], 2, 0)]
}

module "public_ip_gateway" {
  source              = "../public_ip"
  count               = var.gateway ? 1 : 0
  location            = var.location
  environment         = var.environment
  workload            = "gw"
  instance            = var.instance
  resource_group_name = module.resource_group.name
  tags                = local.tags
}

module "gateway" {
  source               = "../virtual_network_gateway"
  count                = var.gateway ? 1 : 0
  location             = var.location
  environment          = var.environment
  workload             = var.workload
  instance             = var.instance
  resource_group_name  = module.resource_group.name
  public_ip_address_id = module.public_ip_gateway[0].id
  subnet_id            = module.subnet_gateway[0].id
  type                 = var.gateway_type
  sku                  = var.gateway_sku
  tags                 = local.tags
}

module "gateway_diagnostic_setting" {
  source                     = "../monitor_diagnostic_setting"
  count                      = var.gateway ? 1 : 0
  target_resource_id         = module.gateway[0].id
  log_analytics_workspace_id = module.log_analytics_workspace.id
}

module "route_table_gateway" {
  source              = "../route_table"
  count               = (var.gateway && var.firewall) ? 1 : 0
  location            = var.location
  environment         = var.environment
  workload            = "gw"
  instance            = var.instance
  resource_group_name = module.resource_group.name
  tags                = local.tags
}

module "subnet_route_table_association_gateway" {
  source         = "../subnet_route_table_association"
  count          = (var.gateway && var.firewall) ? 1 : 0
  subnet_id      = module.subnet_gateway[0].id
  route_table_id = module.route_table_gateway[0].id

  depends_on = [
    module.gateway
  ]
}

module "subnet_firewall" {
  source               = "../subnet"
  count                = var.firewall ? 1 : 0
  location             = var.location
  custom_name          = "AzureFirewallSubnet"
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.virtual_network.name
  address_prefixes     = [cidrsubnet(var.address_space[0], 2, 1)]
}

module "public_ip_firewall" {
  source              = "../public_ip"
  count               = var.firewall ? 1 : 0
  location            = var.location
  environment         = var.environment
  workload            = "fw"
  instance            = var.instance
  resource_group_name = module.resource_group.name
  tags                = local.tags
}

module "firewall_policy" {
  source              = "../firewall_policy"
  count               = var.firewall ? 1 : 0
  location            = var.location
  environment         = var.environment
  workload            = var.workload
  instance            = var.instance
  resource_group_name = module.resource_group.name
  dns_servers         = var.dns_servers
  dns_proxy_enabled   = var.dns_servers != [] ? true : false
  tags                = local.tags
}

module "firewall" {
  source                     = "../firewall"
  count                      = var.firewall ? 1 : 0
  location                   = var.location
  environment                = var.environment
  workload                   = var.workload
  instance                   = var.instance
  resource_group_name        = module.resource_group.name
  firewall_policy_id         = module.firewall_policy[0].id
  public_ip_address_id       = module.public_ip_firewall[0].id
  subnet_id                  = module.subnet_firewall[0].id
  log_analytics_workspace_id = module.log_analytics_workspace.id
  sku_tier                   = var.firewall_sku
  tags                       = local.tags
}

module "firewall_diagnostic_setting" {
  source                     = "../monitor_diagnostic_setting"
  count                      = var.firewall ? 1 : 0
  target_resource_id         = module.firewall[0].id
  log_analytics_workspace_id = module.log_analytics_workspace.id
}

module "firewall_workbook" {
  source              = "../firewall_workbook"
  count               = var.firewall ? 1 : 0
  location            = var.location
  resource_group_name = module.resource_group.name
  tags                = local.tags
}

resource "azurerm_firewall_policy_rule_collection_group" "this" {
  count              = (var.firewall && var.firewall_default_rules) ? 1 : 0
  name               = "default-rules"
  firewall_policy_id = module.firewall_policy[0].id
  priority           = 100

  network_rule_collection {
    name     = "internal"
    priority = 100
    action   = "Allow"
    rule {
      name                  = "private-private-any"
      protocols             = ["TCP", "UDP", "ICMP"]
      source_addresses      = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
      destination_addresses = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
      destination_ports     = ["*"]
    }
  }
  network_rule_collection {
    name     = "web"
    priority = 200
    action   = "Allow"
    rule {
      name                  = "private-internet-web"
      protocols             = ["TCP"]
      source_addresses      = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
      destination_addresses = ["*"]
      destination_ports     = ["80", "443"]
    }
  }
  network_rule_collection {
    name     = "admin"
    priority = 300
    action   = "Allow"
    rule {
      name                  = "private-azure-kms"
      protocols             = ["TCP"]
      source_addresses      = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
      destination_addresses = ["20.118.99.224", "40.83.235.53"]
      destination_ports     = ["1688"]
    }
    rule {
      name                  = "private-azure-ntp"
      protocols             = ["UDP"]
      source_addresses      = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
      destination_addresses = ["51.145.123.29"]
      destination_ports     = ["123"]
    }
  }
}

module "subnet_bastion" {
  source               = "../subnet"
  count                = var.bastion ? 1 : 0
  location             = var.location
  custom_name          = "AzureBastionSubnet"
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.virtual_network.name
  address_prefixes     = [cidrsubnet(var.address_space[0], 2, 2)]
}

module "public_ip_bastion" {
  source              = "../public_ip"
  count               = var.bastion ? 1 : 0
  location            = var.location
  environment         = var.environment
  workload            = "bas"
  instance            = var.instance
  resource_group_name = module.resource_group.name
  tags                = local.tags
}

module "bastion" {
  source               = "../bastion_host"
  count                = var.bastion ? 1 : 0
  location             = var.location
  environment          = var.environment
  workload             = var.workload
  instance             = var.instance
  resource_group_name  = module.resource_group.name
  public_ip_address_id = module.public_ip_bastion[0].id
  subnet_id            = module.subnet_bastion[0].id
  sku                  = var.bastion_sku
  tags                 = local.tags
}

module "bastion_diagnostic_setting" {
  source                     = "../monitor_diagnostic_setting"
  count                      = var.bastion ? 1 : 0
  target_resource_id         = module.bastion[0].id
  log_analytics_workspace_id = module.log_analytics_workspace.id
}

module "user_assigned_identity" {
  source              = "../user_assigned_identity"
  location            = var.location
  environment         = var.environment
  workload            = var.workload_management
  instance            = var.instance
  resource_group_name = module.resource_group_management.name
  tags                = local.tags
}

module "key_vault" {
  source              = "../key_vault"
  count               = var.key_vault ? 1 : 0
  tenant_id           = data.azurerm_client_config.current.tenant_id
  location            = var.location
  environment         = var.environment
  workload            = var.workload_management
  instance            = var.instance
  resource_group_name = module.resource_group_management.name
  access_policy = [
    {
      tenant_id = data.azurerm_client_config.current.tenant_id
      object_id = data.azurerm_client_config.current.object_id
      secret_permissions = [
        "Get",
        "List",
        "Set",
        "Delete",
        "Recover",
        "Backup",
        "Restore",
        "Purge"
      ]
      key_permissions = []
      certificate_permissions = [
        "Get",
        "List",
        "Update",
        "Create",
        "Import",
        "Delete",
        "Recover",
        "Backup",
        "Restore",
        "ManageContacts",
        "ManageIssuers",
        "GetIssuers",
        "ListIssuers",
        "SetIssuers",
        "DeleteIssuers",
        "Purge"
      ]
      storage_permissions = []
    },
    {
      tenant_id = data.azurerm_client_config.current.tenant_id
      object_id = module.user_assigned_identity.uuid
      secret_permissions = [
        "Get",
        "List",
        "Set",
        "Delete",
        "Recover",
        "Backup",
        "Restore",
        "Purge"
      ]
      key_permissions = []
      certificate_permissions = [
        "Get",
        "List",
        "Update",
        "Create",
        "Import",
        "Delete",
        "Recover",
        "Backup",
        "Restore",
        "ManageContacts",
        "ManageIssuers",
        "GetIssuers",
        "ListIssuers",
        "SetIssuers",
        "DeleteIssuers",
        "Purge"
      ]
      storage_permissions = []
    }
  ]
  network_acls = [
    {
      bypass                     = "AzureServices"
      default_action             = "Deny"
      ip_rules                   = [data.http.ipinfo[0].response_body]
      virtual_network_subnet_ids = []
    }
  ]
  tags = local.tags
}

module "key_vault_diagnostic_setting" {
  source                     = "../monitor_diagnostic_setting"
  count                      = var.key_vault ? 1 : 0
  target_resource_id         = module.key_vault[0].id
  log_analytics_workspace_id = module.log_analytics_workspace.id
}

module "storage_account" {
  count                        = var.storage_account ? 1 : 0
  source                       = "../storage_account"
  location                     = var.location
  environment                  = var.environment
  workload                     = var.workload_management
  resource_group_name          = module.resource_group_management.name
  network_rules_default_action = "Deny"
  network_rules_bypass         = ["AzureServices"]
  network_rules_ip_rules       = [data.http.ipinfo[0].response_body]
  tags                         = local.tags
}

# module "storage_account_diagnostic_setting" {
#   source                     = "../monitor_diagnostic_setting"
#   count                      = var.storage_account ? 1 : 0
#   target_resource_id         = module.storage_account[0].id
#   log_analytics_workspace_id = module.log_analytics_workspace.id
# }