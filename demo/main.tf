module "hub_and_spoke" {
  source                                 = "../modules/pattern_hub_and_spoke"
  location                               = var.location
  firewall                               = var.firewall
  gateway                                = var.gateway
  bastion                                = var.bastion
  address_space_hub                      = var.address_space_hub
  spoke_dns                              = var.spoke_dns
  address_space_spoke_dns                = var.address_space_spoke_dns
  spoke_dmz                              = var.spoke_dmz
  address_space_spoke_dmz                = var.address_space_spoke_dmz
  web_application_firewall               = var.spoke_dmz
  private_monitoring                     = var.private_monitoring
  address_space_spoke_private_monitoring = var.address_space_spoke_private_monitoring
  connection_monitor                     = var.connection_monitor
  update_management                      = var.update_management
  network_security_group                 = var.network_security_group
  backup                                 = var.backup
  address_space_spokes                   = var.address_space_spokes
}