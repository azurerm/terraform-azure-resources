output "resource_group_name" {
  description = "The name of the resource group of the spoke."
  value       = module.resource_group.name
}

output "virtual_network_name" {
  description = "The name of the virtual network of the spoke."
  value       = module.virtual_network.name
}

output "virtual_network_id" {
  description = "The ID of the spoke."
  value       = module.virtual_network.id
}

output "inbound_endpoint_ip" {
  description = "The IP address of the Private DNS Resolver Inbound Endpoint."
  value       = module.private_dns_resolver.inbound_endpoint_ip
}

output "address_space" {
  description = "The address space of the virtual network."
  value       = var.address_space
}

output "private_dns_zones" {
  description = "The IDs of the private DNS zones."
  value       = module.private_dns_zones
}