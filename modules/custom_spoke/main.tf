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
      terraform-module-composable = "azurerm/resources/azure//modules/custom_spoke"
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

module "rg" {
  source      = "../resource_group"
  location    = var.location
  environment = var.environment
  workload    = var.workload
  instance    = var.instance
  tags        = local.tags
}

module "vnet" {
  source              = "../virtual_network"
  location            = var.location
  environment         = var.environment
  workload            = var.workload
  instance            = var.instance
  resource_group_name = module.rg.name
  address_space       = var.address_space
  dns_servers         = var.dns_servers
  tags                = local.tags
}

module "subnet" {
  source               = "../subnet"
  count                = var.subnet_count
  location             = var.location
  environment          = var.environment
  workload             = var.workload
  instance             = format("%03d", count.index + 1)
  resource_group_name  = module.rg.name
  virtual_network_name = module.vnet.name
  address_prefixes     = [cidrsubnet(var.address_space[0], ceil(var.subnet_count / 2), count.index)]
}

module "linux_virtual_machine" {
  source              = "../linux_virtual_machine"
  count               = var.linux_virtual_machine ? var.subnet_count : 0
  location            = var.location
  environment         = var.environment
  workload            = var.workload
  instance            = format("%03d", count.index + 1)
  resource_group_name = module.rg.name
  subnet_id           = module.subnet[count.index].id
  tags                = local.tags
}