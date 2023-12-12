output "resource_group_name" {
  description = "The name of the resource group of the spoke."
  value       = module.resource_group.name
}

output "virtual_network_name" {
  description = "The name of the virtual network of the spoke."
  value       = module.virtual_network.name
}

output "virtual_network_id" {
  description = "The ID of the virtual network of the spoke."
  value       = module.virtual_network.id
}

output "key_vault_id" {
  description = "The ID of the Key Vault."
  value       = var.key_vault ? module.key_vault[0].id : null
}

output "firewall_private_ip_address" {
  description = "The private IP address of the Firewall."
  value       = var.firewall ? module.firewall[0].private_ip_address : null
}

output "firewall_public_ip_address" {
  description = "The public IP address of the Firewall."
  value       = var.firewall ? module.public_ip_firewall[0].ip_address : null
}

output "firewall_policy_id" {
  description = "The ID of the Firewall Policy."
  value       = var.firewall ? module.firewall_policy[0].id : null
}

output "route_table_name" {
  description = "The name of the Route Table."
  value       = (var.gateway && var.firewall) ? module.route_table_gateway[0].name : null
}