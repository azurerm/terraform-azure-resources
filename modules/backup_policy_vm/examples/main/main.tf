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
  workload    = "mgt"
  instance    = "001"
}

module "recovery_services_vault" {
  source              = "./modules/recovery_services_vault"
  location            = module.resource_group.location
  environment         = "prd"
  workload            = "mgt"
  resource_group_name = module.resource_group.name
}
