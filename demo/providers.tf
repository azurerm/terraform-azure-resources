terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.74.0"
    }
  }
  backend "azurerm" {
    subscription_id      = "bfa339d4-ee2f-4040-810b-8ce1c3fb4877"
    resource_group_name  = "tfstate"
    storage_account_name = "cloud63tfstate"
    container_name       = "tfstate"
    key                  = "azurerm-azure-resources-demo.tfstate"
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
}