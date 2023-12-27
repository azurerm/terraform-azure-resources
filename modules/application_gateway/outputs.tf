output "id" {
  description = "The ID of the application gateway."
  value       = azurerm_application_gateway.this.id
}

output "name" {
  description = "The name of the application gateway."
  value       = azurerm_application_gateway.this.name
}
