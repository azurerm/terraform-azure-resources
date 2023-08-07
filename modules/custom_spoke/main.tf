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

module "resource_group" {
  source      = "azurerm/resources/azure//modules/resource_group"
  location    = var.location
  environment = var.environment
  workload    = var.workload
  instance    = var.instance
  tags        = local.tags
}

module "virtual_network" {
  source              = "azurerm/resources/azure//modules/virtual_network"
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
  source                                    = "azurerm/resources/azure//modules/subnet"
  count                                     = var.subnet_count
  location                                  = var.location
  environment                               = var.environment
  workload                                  = var.workload
  instance                                  = format("%03d", count.index + 1)
  resource_group_name                       = module.resource_group.name
  virtual_network_name                      = module.virtual_network.name
  address_prefixes                          = [cidrsubnet(var.address_space[0], ceil(var.subnet_count / 2), count.index)]
  private_endpoint_network_policies_enabled = true
}

module "linux_virtual_machine" {
  source              = "azurerm/resources/azure//modules/linux_virtual_machine"
  count               = var.linux_virtual_machine ? var.subnet_count : 0
  location            = var.location
  environment         = var.environment
  workload            = var.workload
  instance            = format("%03d", count.index + 1)
  resource_group_name = module.resource_group.name
  subnet_id           = module.subnet[count.index].id
  size                = var.virtual_machine_size
  tags                = local.tags
}