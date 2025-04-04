terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
  backend "azurerm" {
    use_azuread_auth     = true
    subscription_id      = var.TFSTATE_SUBSCRIPTION_ID
    resource_group_name  = var.TFSTATE_RESOURCE_GROUP
    storage_account_name = var.TFSTATE_STORAGE_ACCOUNT
    container_name       = var.TFSTATE_CONTAINER
    key                  = var.TFSTATE_KEY
   }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}