output "id" {
  description = "The ID of the Network Interface."
  value       = azurerm_network_interface.this.id
}

output "name" {
  description = "The name of the Network Interface."
  value       = azurerm_network_interface.this.name
}

output "resource_group_name" {
  description = "The name of the resource group in which the Network Interface is created."
  value       = azurerm_network_interface.this.resource_group_name
}

output "private_ip_address" {
  description = "The private IP address of the Network Interface."
  value       = azurerm_network_interface.this.private_ip_address
}
