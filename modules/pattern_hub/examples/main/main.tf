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

module "hub" {
  source        = "azurerm/resources/azure//modules/pattern_hub"
  location      = "westeurope"
  environment   = "prd"
  workload      = "hub"
  address_space = ["10.0.1.0/24"]
}