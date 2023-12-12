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
      terraform-azurerm-composable = "custom_spoke"
    }
  )

  tags = merge(
    var.module_tags ? local.module_tags : {},
    var.tags
  )

  linux_virtual_machines = {
    for linux in module.linux_virtual_machine : linux.name => {
      admin_username            = linux.admin_username
      admin_password            = linux.admin_password
      source_image_reference_id = linux.source_image_reference_offer
    }
  }

  windows_virtual_machines = {
    for windows in module.windows_virtual_machine : windows.name => {
      admin_username            = windows.admin_username
      admin_password            = windows.admin_password
      source_image_reference_id = windows.source_image_reference_offer
    }
  }

  virtual_machines = merge(local.linux_virtual_machines, local.windows_virtual_machines)
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
  source                                    = "../subnet"
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

module "routing" {
  source              = "../custom_routing"
  count               = var.subnet_count
  location            = var.location
  environment         = var.environment
  workload            = var.workload
  instance            = var.instance
  resource_group_name = module.resource_group.name
  default_next_hop    = var.default_next_hop
  subnet_id           = module.subnet[count.index].id
  tags                = local.tags
}

module "linux_virtual_machine" {
  source              = "../linux_virtual_machine"
  count               = var.linux_virtual_machine ? var.subnet_count : 0
  location            = var.location
  environment         = var.environment
  workload            = var.workload
  instance            = format("%03d", count.index + 1)
  resource_group_name = module.resource_group.name
  subnet_id           = module.subnet[count.index].id
  tags                = local.tags
}

module "windows_virtual_machine" {
  source              = "../windows_virtual_machine"
  count               = var.windows_virtual_machine ? var.subnet_count : 0
  location            = var.location
  environment         = var.environment
  workload            = var.workload
  instance            = format("%03d", count.index + 1)
  resource_group_name = module.resource_group.name
  subnet_id           = module.subnet[count.index].id
  tags                = local.tags
}