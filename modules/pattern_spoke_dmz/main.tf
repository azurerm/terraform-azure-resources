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
      terraform-azurerm-composable-level2 = "pattern_spoke_dmz"
    }
  )

  tags = merge(
    var.module_tags ? local.module_tags : {},
    var.tags
  )
}

data "azurerm_client_config" "current" {}

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
  address_prefixes     = [var.address_space[0]]
  delegation = {
    "applicationGateway" = {
      name = "Microsoft.Network/applicationGateways"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

module "routing" {
  source              = "../pattern_routing"
  count               = var.firewall ? 1 : 0
  location            = var.location
  environment         = var.environment
  workload            = var.workload
  instance            = var.instance
  resource_group_name = module.resource_group.name
  routing_type        = "private"
  next_hop            = var.next_hop
  subnet_id           = module.subnet.id
  tags                = local.tags
}

module "web_application_firewall_policy" {
  source              = "../web_application_firewall_policy"
  count               = var.web_application_firewall ? 1 : 0
  location            = var.location
  environment         = var.environment
  workload            = var.workload
  instance            = var.instance
  resource_group_name = module.resource_group.name
  tags                = local.tags
}

module "public_ip" {
  source              = "../public_ip"
  location            = var.location
  environment         = var.environment
  workload            = var.workload
  instance            = var.instance
  resource_group_name = module.resource_group.name
  allocation_method   = "Static"
  domain_name_label   = "x${uuidv5("dns", data.azurerm_client_config.current.subscription_id)}"
  tags                = local.tags
}

module "application_gateway" {
  source               = "../application_gateway"
  location             = var.location
  environment          = var.environment
  workload             = var.workload
  instance             = var.instance
  resource_group_name  = module.resource_group.name
  subnet_id            = module.subnet.id
  public_ip_address_id = module.public_ip.id
  firewall_policy_id   = var.web_application_firewall ? module.web_application_firewall_policy[0].id : null
  sku_name             = var.web_application_firewall ? "WAF_v2" : "Standard_v2"
  sku_tier             = var.web_application_firewall ? "WAF_v2" : "Standard_v2"
  tags                 = local.tags
}

module "application_gateway_diagnostic_setting" {
  source                     = "../monitor_diagnostic_setting"
  target_resource_id         = module.application_gateway.id
  log_analytics_workspace_id = var.log_analytics_workspace_id
}
