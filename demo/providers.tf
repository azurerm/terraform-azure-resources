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
    subscription_id      = "97e606b4-56f0-40ca-bcf4-75f315e28564"
    resource_group_name  = "rg-tf-prd-ne-001"
    storage_account_name = "satfprdne001"
    container_name       = "tfstate"
    key                  = "azurerm-azure-resources-demo.tfstate"
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