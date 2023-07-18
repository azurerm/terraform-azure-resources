output "id" {
  description = "The ID of the Subnet."
  value       = azurerm_subnet.this.id
}

output "name" {
  description = "The name of the Subnet."
  value       = azurerm_subnet.this.name
}
