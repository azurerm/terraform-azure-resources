output "id" {
  description = "The ID of the AI Services."
  value       = azurerm_ai_services.this.id
}

output "name" {
  description = "The name of the AI Services."
  value       = azurerm_ai_services.this.name
}

output "custom_subdomain_name" {
  description = "The custom subdomain name of the AI Services."
  value       = azurerm_ai_services.this.custom_subdomain_name
}

output "primary_access_key" {
  description = "The primary access key of the AI Services."
  sensitive   = true
  value       = azurerm_ai_services.this.primary_access_key
}

output "identity" {
  description = "The identity of the AI Services."
  value       = azurerm_ai_services.this.identity
}