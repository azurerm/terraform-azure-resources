output "id" {
  description = "The ID of the Virtual Network Gateway."
  value       = azurerm_virtual_network_gateway.this.id
}

output "name" {
  description = "The name of the Virtual Network Gateway."
  value       = azurerm_virtual_network_gateway.this.name
}

output "resource_group_name" {
  description = "The name of the resource group in which to create the Virtual Network Gateway."
  value       = azurerm_virtual_network_gateway.this.resource_group_name
}