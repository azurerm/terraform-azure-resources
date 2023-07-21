output "id" {
  description = "The ID of the Public IP."
  value       = azurerm_public_ip.this.id
}

output "name" {
  description = "The name of the Public IP."
  value       = azurerm_public_ip.this.name
}

output "ip_address" {
  description = "The IP address associated with the Public IP."
  value       = azurerm_public_ip.this.ip_address
}

output "fqdn" {
  description = "The FQDN associated with the Public IP."
  value       = azurerm_public_ip.this.fqdn
}