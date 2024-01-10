output "resource_group_name" {
  description = "The name of the resource group of the spoke."
  value       = module.resource_group.name
}

output "virtual_network_id" {
  description = "The ID of the virtual network."
  value       = module.virtual_network.id
}

output "address_space" {
  description = "The address space of the virtual network."
  value       = var.address_space
}

output "monitor_data_collection_rule_id" {
  description = "The monitor data collection rule."
  value       = azurerm_monitor_data_collection_rule.this.id
}

output "monitor_data_collection_endpoint_id" {
  description = "The monitor data collection endpoint."
  value       = azurerm_monitor_data_collection_endpoint.this.id
}