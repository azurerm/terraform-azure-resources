terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "spoke_jumphost" {
  source        = "azurerm/resources/azure//modules/custom_spoke_jumphost"
  location      = "westeurope"
  address_space = ["10.0.3.0/24"]
}