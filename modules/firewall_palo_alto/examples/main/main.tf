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
  environment = "prd"
  workload    = "hub"
  instance    = "001"
}

module "virtual_network" {
  source              = "azurerm/resources/azure//modules/virtual_network"
  location            = "westeurope"
  environment         = "prd"
  workload            = "hub"
  instance            = "001"
  resource_group_name = module.resource_group.name
  address_space       = ["10.0.0.0/24"]
}

module "subnet" {
  source               = "azurerm/resources/azure//modules/subnet"
  location             = "westeurope"
  custom_name          = "AzureFirewallSubnet"
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.virtual_network.name
  address_prefixes     = ["10.0.0.0/25"]
}

module "publicip" {
  source              = "azurerm/resources/azure//modules/public_ip"
  location            = "westeurope"
  environment         = "prd"
  workload            = "firewall"
  instance            = "001"
  resource_group_name = module.resource_group.name
}

module "firewall" {
  source               = "azurerm/resources/azure//modules/firewall"
  location             = "westeurope"
  environment          = "prd"
  workload             = "firewall"
  instance             = "001"
  resource_group_name  = module.resource_group.name
  public_ip_address_id = module.publicip.id
  subnet_id            = module.subnet.id
}