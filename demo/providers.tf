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
    subscription_id      = ${{ secrets.tfstate_subscription_id }}
    resource_group_name  = ${{ secrets.tfstate_resource_group_name }}
    storage_account_name = ${{ secrets.tfstate_storage_account_name }}
    container_name       = ${{ secrets.tfstate_container_name }}
    key                  = ${{ secrets.tfstate_key }}
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
