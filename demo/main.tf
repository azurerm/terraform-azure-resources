module "hub_and_spoke" {
  source                                 = "../modules/pattern_hub_and_spoke"
  ip_filter                              = var.ip_filter
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
  additional_access_policy_object_ids    = var.additional_access_policy_object_ids
}

module "standalone_site" {
  source        = "../modules/pattern_standalone_site"
  count         = var.standalone_site ? 1 : 0
  location      = var.location
  address_space = var.address_space_standalone_site
}