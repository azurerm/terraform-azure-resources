output "id" {
  description = "The ID of the Private DNS Resolver."
  value       = azurerm_private_dns_resolver.this.id
}

output "name" {
  description = "The name of the Private DNS Resolver."
  value       = azurerm_private_dns_resolver.this.name
}

output "resource_group_name" {
  description = "The name of the resource group in which to create Private DNS Resolver."
  value       = azurerm_private_dns_resolver.this.resource_group_name
}

output "inbound_endpoint_ip" {
  description = "The IP address of the Private DNS Resolver Inbound Endpoint."
  value       = azurerm_private_dns_resolver_inbound_endpoint.this.ip_configurations[0].private_ip_address
}

output "outbound_endpoint_id" {
  description = "The ID of the Private DNS Resolver Outbound Endpoint."
  value       = azurerm_private_dns_resolver_outbound_endpoint.this.id
}