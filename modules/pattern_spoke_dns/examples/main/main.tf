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

module "spoke_dns" {
  source        = "azurerm/resources/azure//modules/pattern_spoke_dns"
  location      = "westeurope"
  address_space = ["10.0.3.0/24"]
  dns_forwarding_rules = [
    {
      domain_name = "example.com."
      target_dns_servers = [
        {
          ip_address = "192.168.10.5"
          port       = 53
        }
      ]
    },
    {
      domain_name = "example2.com."
      target_dns_servers = [
        {
          ip_address = "192.168.10.5"
          port       = 53
        }
      ]
    }
  ]
}