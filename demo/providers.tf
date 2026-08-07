# NOTE (azurerm 5.x): this demo builds on pattern_hub_and_spoke -> pattern_hub ->
# firewall_palo_alto, which depends on PaloAltoNetworks/swfw-modules (azurerm
# ~> 4.62, i.e. < 5.0). While that module is referenced, `terraform init` cannot
# resolve an azurerm 5.x provider for this configuration. The standalone leaf
# modules are azurerm 5.x-ready; the Palo Alto path is blocked upstream until PAN
# ships 5.x support.
terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.0"
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