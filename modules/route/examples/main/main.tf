terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "resource_group" {
  source      = "azurerm/resources/azure//modules/resource_group"
  location    = "westeurope"
  environment = "dev"
  workload    = "example"
  instance    = "001"
}

module "route_table" {
  source              = "azurerm/resources/azure//modules/route_table"
  resource_group_name = module.resource_group.name
  location            = "westeurope"
  environment         = "dev"
  workload            = "example"
  instance            = "001"
}

module "route" {
  source              = "azurerm/resources/azure//modules/route"
  resource_group_name = module.resource_group.name
  route_table_id      = module.route_table.id
  name                = "example"
  address_prefix      = "10.0.0.0/24"
  next_hop_type       = "VirtualAppliance"
  next_hop_in_ip      = "10.0.1.4"
}