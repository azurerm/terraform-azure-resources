output "resource_group_name" {
  description = "The name of the resource group of the spoke."
  value       = module.resource_group.name
}

output "virtual_network_name" {
  description = "The name of the virtual network of the spoke."
  value       = module.virtual_network.name
}

output "virtual_network_id" {
  description = "The ID of the spoke."
  value       = module.virtual_network.id
}

output "address_space" {
  description = "The address space of the virtual network."
  value       = var.address_space
}

output "storage_account_id" {
  description = "The ID of the storage account."
  value       = module.storage_account.id
}

output "container_name" {
  description = "The name of the container."
  value       = azurerm_storage_container.this.name
}

output "search_service_name" {
  description = "The name of the search service."
  value       = azurerm_search_service.this.name
}

output "search_service_key" {
  description = "The key of the search service."
  sensitive   = true
  value       = azurerm_search_service.this.primary_key
}