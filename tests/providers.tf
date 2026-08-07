# NOTE (azurerm 5.x): the tests exercise pattern_hub_and_spoke, which references
# firewall_palo_alto (PaloAltoNetworks/swfw-modules, azurerm ~> 4.62 / < 5.0).
# `terraform init`/`test` cannot resolve azurerm 5.x while that module is in the
# graph. Standalone leaf modules are 5.x-ready; the Palo Alto path is blocked
# upstream until PAN ships 5.x support.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "a6d7be0b-75a9-44d6-80ee-d5fcc0aa8e76"
}