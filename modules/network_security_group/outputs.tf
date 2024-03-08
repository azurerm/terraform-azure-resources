output "id" {
  description = "The ID of the Network Security Group."
  value       = azurerm_network_security_group.this.id
}

output "name" {
  description = "The name of the Network Security Group."
  value       = azurerm_network_security_group.this.name
}

output "resource_group_name" {
  description = "The name of the resource group in which the Network Interface is created."
  value       = azurerm_network_security_group.this.resource_group_name
}

