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
      terraform-azurerm-composable-level1 = "pattern_standalone_site"
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
  workload            = var.workload
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
  workload            = var.workload
  instance            = var.instance
  resource_group_name = module.resource_group.name
}

module "firewall" {
  source               = "../firewall"
  count                = var.firewall ? 1 : 0
  location             = var.location
  environment          = var.environment
  workload             = var.workload
  instance             = var.instance
  resource_group_name  = module.resource_group.name
  public_ip_address_id = module.public_ip_firewall[0].id
  subnet_id            = module.subnet_firewall[0].id
}

module "subnet_workload" {
  source               = "../subnet"
  location             = var.location
  environment          = var.environment
  workload             = var.workload
  instance             = var.instance
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.virtual_network.name
  address_prefixes     = [cidrsubnet(var.address_space[0], 2, 2)]
}

module "linux_virtual_machine" {
  source              = "../linux_virtual_machine"
  count               = var.linux_virtual_machine ? 1 : 0
  location            = var.location
  environment         = var.environment
  workload            = var.workload
  instance            = var.instance
  resource_group_name = module.resource_group.name
  subnet_id           = module.subnet_workload.id
  size                = var.virtual_machine_size
  tags                = local.tags
}