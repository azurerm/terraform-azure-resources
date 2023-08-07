output "id" {
  description = "The ID of the Virutal Network Peering."
  value       = azurerm_virtual_network_peering.this.id
}

output "name" {
  description = "The name of the Virutal Network Peering."
  value       = azurerm_virtual_network_peering.this.name
}
