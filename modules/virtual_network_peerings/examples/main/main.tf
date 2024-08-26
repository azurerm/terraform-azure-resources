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
  source      = "./modules/resource_group"
  location    = "westeurope"
  environment = "dev"
  workload    = "example"
  instance    = "001"
}

module "virtual_network_1" {
  source              = "azurerm/resources/azure//modules/virtual_network"
  location            = "westeurope"
  environment         = "dev"
  workload            = "example"
  instance            = "001"
  resource_group_name = module.resource_group.name
  address_space       = ["10.0.0.0/24"]
}

module "virtual_network_2" {
  source              = "azurerm/resources/azure//modules/virtual_network"
  location            = "westeurope"
  environment         = "dev"
  workload            = "example"
  instance            = "002"
  resource_group_name = module.resource_group.name
  address_space       = ["10.0.1.0/24"]
}

module "virtual_network_peerings" {
  source                                = "azurerm/resources/azure//modules/virtual_network_peerings"
  virtual_network_1_resource_group_name = module.resource_group.name
  virtual_network_1_id                  = module.virtual_network_1.id
  virtual_network_2_resource_group_name = module.resource_group.name
  virtual_network_2_id                  = module.virtual_network_2.id
}
