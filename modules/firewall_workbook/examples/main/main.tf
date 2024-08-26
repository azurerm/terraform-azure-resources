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

module "firewall_workbook" {
  source              = "./modules/firewall_workbook"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  display_name        = "Firewall Workbook"
  url                 = "https://raw.githubusercontent.com/Azure/azure-docs-json-samples/master/azure-firewall/azure-firewall-workbook.json"
}