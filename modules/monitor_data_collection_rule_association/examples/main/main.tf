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

module "data_collection_endpoint_association" {
  source                      = "azurerm/resources/azure//modules/monitor_data_collection_rule_association"
  target_resource_id          = var.target_resource_id
  data_collection_endpoint_id = var.data_collection_endpoint_id
}
