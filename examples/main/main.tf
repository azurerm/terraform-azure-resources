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

module "hub_and_spoke" {
  source                                 = "azurerm/resources/azure//modules/pattern_hub_and_spoke"
  location                               = "francecentral"
  firewall                               = true
  gateway                                = true
  bastion                                = true
  address_space_hub                      = ["10.100.0.0/24"]
  spoke_dns                              = true
  address_space_spoke_dns                = ["10.100.1.0/24"]
  spoke_dmz                              = true
  address_space_spoke_dmz                = ["10.100.2.0/24"]
  web_application_firewall               = true
  private_monitoring                     = true
  address_space_spoke_private_monitoring = ["10.100.3.0/27"]
  connection_monitor                     = true
  update_management                      = true
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
