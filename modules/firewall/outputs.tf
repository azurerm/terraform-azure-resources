output "id" {
  description = "The ID of the Firewall."
  value       = azurerm_firewall.this.id
}

output "name" {
  description = "The name of the Firewall."
  value       = azurerm_firewall.this.name
}

output "resource_group_name" {
  description = "The name of the resource group in which to create the Firewall."
  value       = azurerm_firewall.this.resource_group_name
}