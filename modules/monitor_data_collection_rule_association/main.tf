terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

resource "azurerm_monitor_data_collection_rule_association" "this" {
  name                        = var.name
  target_resource_id          = var.target_resource_id
  data_collection_rule_id     = var.data_collection_rule_id
  data_collection_endpoint_id = var.data_collection_endpoint_id
  description                 = var.description
}
