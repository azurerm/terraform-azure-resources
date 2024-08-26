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

module "standalone_site" {
  source        = "azurerm/resources/azure//modules/pattern_standalone_site"
  location      = "westeurope"
  address_space = ["10.120.0.0/23"]
}