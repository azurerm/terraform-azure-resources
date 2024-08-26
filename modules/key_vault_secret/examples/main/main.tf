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

module "resource_group" {
  source      = "azurerm/resources/azure//modules/resource_group"
  location    = "westeurope"
  environment = "dev"
  workload    = "example"
  instance    = "001"
}

module "key_vault" {
  source              = "azurerm/resources/azure//modules/key_vault"
  resource_group_name = module.resource_group.name
  location            = "westeurope"
  environment         = "dev"
  workload            = "example"
  instance            = "001"
}

module "key_vault_secret" {
  source              = "azurerm/resources/azure//modules/key_vault_secret"
  resource_group_name = module.resource_group.name
  key_vault_name      = module.key_vault.name
  secret_name         = "example"
  secret_value        = "example"
}