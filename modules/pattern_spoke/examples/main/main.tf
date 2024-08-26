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

module "spoke" {
  source        = "azurerm/resources/azure//modules/pattern_spoke"
  location      = "westeurope"
  environment   = "dev"
  workload      = "example"
  address_space = ["10.0.1.0/24"]
  subnet_count  = 2
}