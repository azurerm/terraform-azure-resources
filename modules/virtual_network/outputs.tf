output "id" {
  description = "The ID of the Virtual Network."
  value       = azurerm_virtual_network.this.id
}

output "name" {
  description = "The name of the Virtual Network."
  value       = azurerm_virtual_network.this.name
}

output "resource_group_name" {
  description = "The name of the resource group in which to create the Virtual Network."
  value       = azurerm_virtual_network.this.resource_group_name
}