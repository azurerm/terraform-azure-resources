output "id" {
  description = "The ID of the Firewall Policy."
  value       = azurerm_firewall_policy.this.id
}

output "name" {
  description = "The name of the Firewall."
  value       = azurerm_firewall_policy.this.name
}

output "resource_group_name" {
  description = "The name of the resource group in which to create the Firewall."
  value       = azurerm_firewall_policy.this.resource_group_name
}