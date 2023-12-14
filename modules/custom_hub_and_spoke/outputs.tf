output "hub_resource_group_name" {
  description = "The name of the resource group of the spoke."
  value       = module.hub.resource_group_name
}

output "firewall_public_ip_address" {
  description = "The public IP address of the Firewall."
  value       = var.firewall ? module.hub.firewall_public_ip_address : null
}