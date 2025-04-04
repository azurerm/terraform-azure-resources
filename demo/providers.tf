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
    subscription_id      = "76cd9994-a78e-45dd-839a-1e14f89c1d66"
    resource_group_name  = "rg-tf-prd-ne-001"
    storage_account_name = "satfprdne001armand"
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