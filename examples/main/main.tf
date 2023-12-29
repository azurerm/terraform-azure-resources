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

module "custom_hub_and_spoke" {
  source                   = "../../modules/custom_hub_and_spoke"
  location                 = "francecentral"
  firewall                 = true
  gateway                  = true
  bastion                  = true
  address_space_hub        = ["10.100.0.0/24"]
  spoke_dns                = true
  address_space_spoke_dns  = ["10.100.1.0/24"]
  spoke_jumphost           = true
  address_space_spoke_dmz  = ["10.100.2.0/24"]
  web_application_firewall = true
  address_space_spokes = [
    {
      workload        = "shared"
      environment     = "prd"
      instance        = "001"
      address_space   = ["10.100.5.0/24"]
      virtual_machine = false
    },
    {
      workload        = "app1"
      environment     = "dev"
      instance        = "001"
      address_space   = ["10.100.10.0/24"]
      virtual_machine = true
    }
  ]
}
