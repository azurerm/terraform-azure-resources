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
      terraform-azurerm-module = "routing"
    }
  )

  tags = merge(
    var.module_tags ? local.module_tags : {},
    var.workload != "" ? { workload = var.workload } : {},
    var.environment != "" ? { environment = var.environment } : {},
    var.tags
  )
}

module "route_table" {
  source                        = "../route_table"
  custom_name                   = var.custom_name
  location                      = var.location
  environment                   = var.environment
  workload                      = var.workload
  instance                      = var.instance
  resource_group_name           = var.resource_group_name
  disable_bgp_route_propagation = true
  tags                          = local.tags
}

module "route" {
  source                 = "../route"
  resource_group_name    = var.resource_group_name
  route_table_name       = module.route_table.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.default_next_hop
}

module "subnet_route_table_association" {
  source         = "../subnet_route_table_association"
  subnet_id      = var.subnet_id
  route_table_id = module.route_table.id
}