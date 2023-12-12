terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

# resource "azurerm_firewall_policy_rule_collection_group" "this" {
#   name               = var.name
#   firewall_policy_id = var.firewall_policy_id
#   priority           = var.priority

#   dynamic "rule_collection" {
#     for_each = var.rule_collection

#     content {
#       name = rule_collection.value.name

#       dynamic "rule" {
#         for_each = rule_collection.value.rule

#         content {
#           name                           = rule.value.name
#           description                    = rule.value.description
#           source_addresses               = rule.value.source_addresses
#           destination_addresses          = rule.value.destination_addresses
#           destination_ports              = rule.value.destination_ports
#           destination_fqdns              = rule.value.destination_fqdns
#           protocols                      = rule.value.protocols
#           source_ip_groups               = rule.value.source_ip_groups
#           destination_ip_groups          = rule.value.destination_ip_groups
#           source_ip_addresses            = rule.value.source_ip_addresses
#           destination_ip_addresses       = rule.value.destination_ip_addresses
#           source_ports                   = rule.value.source_ports
#           ip_protocols                   = rule.value.ip_protocols
#           target_fqdns                   = rule.value.target_fqdns
#           target_urls                    = rule.value.target_urls
#           target_fqdn_tags               = rule.value.target_fqdn_tags
#           azure_firewall_application_rule = rule.value.azure_firewall_application_rule
#           azure_firewall_network_rule    = rule.value.azure_firewall_network_rule
#           action                         = rule.value.action
#           rule_type                      = rule.value.rule_type
#           priority                       = rule.value.priority
#         }
#      }
# }