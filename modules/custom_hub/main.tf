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
      terraform-azurerm-composable = "custom_hub"
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

module "log_analytics_workspace" {
  source              = "../log_analytics_workspace"
  location            = var.location
  environment         = var.environment
  workload            = var.workload
  instance            = var.instance
  resource_group_name = module.resource_group.name
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
}

module "bastion_diagnostic_setting" {
  source                     = "../monitor_diagnostic_setting"
  count                      = var.bastion ? 1 : 0
  target_resource_id         = module.bastion[0].id
  log_analytics_workspace_id = module.log_analytics_workspace.id
}

module "key_vault" {
  source              = "../key_vault"
  count               = var.key_vault ? 1 : 0
  tenant_id           = data.azurerm_client_config.current.tenant_id
  location            = var.location
  environment         = var.environment
  workload            = var.workload
  instance            = var.instance
  resource_group_name = module.resource_group.name
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
      key_permissions         = []
      certificate_permissions = []
      storage_permissions     = []
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