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

module "spoke_dmz" {
  source                   = "../pattern_spoke_dmz"
  location                 = "westeurope"
  address_space            = ["10.0.10.0/24"]
  web_application_firewall = true
}
