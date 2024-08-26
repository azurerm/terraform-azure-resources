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
  source            = "azurerm/resources/azure//modules/pattern_hub_and_spoke"
  location          = "westeurope"
  address_space_hub = ["10.100.0.0/24"]
  address_space_spokes = [
    {
      workload      = "app1"
      environment   = "dev"
      instance      = "001"
      address_space = ["10.100.1.0/24"]
    },
    {
      workload      = "app2"
      environment   = "dev"
      instance      = "001"
      address_space = ["10.100.2.0/24"]
    },
    {
      workload      = "app1"
      environment   = "prd"
      instance      = "001"
      address_space = ["10.110.1.0/24"]
    },
    {
      workload      = "app2"
      environment   = "prd"
      instance      = "001"
      address_space = ["10.110.2.0/24"]
    }
  ]
}
