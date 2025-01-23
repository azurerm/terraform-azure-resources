module "hub_and_spoke" {
  source                                 = "../modules/pattern_hub_and_spoke"
  ip_filter                              = var.ip_filter
  private_paas                           = var.private_paas
  location                               = var.location
  firewall                               = var.firewall
  firewall_sku                           = var.firewall_sku
  firewall_palo_alto                     = var.firewall_palo_alto
  gateway                                = var.gateway
  p2s_vpn                                = var.p2s_vpn
  bastion                                = var.bastion
  key_vault                              = var.key_vault
  address_space_hub                      = var.address_space_hub
  spoke_dns                              = var.spoke_dns
  address_space_spoke_dns                = var.address_space_spoke_dns
  spoke_dmz                              = var.spoke_dmz
  address_space_spoke_dmz                = var.address_space_spoke_dmz
  web_application_firewall               = var.spoke_dmz
  spoke_ai                               = var.spoke_ai
  address_space_spoke_ai                 = var.address_space_spoke_ai
  private_monitoring                     = var.private_monitoring
  address_space_spoke_private_monitoring = var.address_space_spoke_private_monitoring
  connection_monitor                     = var.connection_monitor
  update_management                      = var.update_management
  network_security_group                 = var.network_security_group
  backup                                 = var.backup
  additional_access_policy_object_ids    = var.additional_access_policy_object_ids
  address_space_spokes = [for s in range(1, var.spokes_count + 1) :
    {
      workload         = "app${s}"
      environment      = "prd"
      instance         = "001"
      address_space    = ["10.${99 + ceil(s / 255)}.${(s + 9) % 256}.0/24"]
      virtual_machines = var.spokes_virtual_machines
    }
  ]
}

module "standalone" {
  source                              = "../modules/pattern_standalone_site"
  count                               = var.standalone_site
  location                            = var.location
  workload                            = "dc${count.index + 1}"
  gateway                             = var.gateway
  address_space                       = ["10.200.${count.index}.0/24"]
  linux_virtual_machine               = var.spokes_virtual_machines
  additional_access_policy_object_ids = var.additional_access_policy_object_ids
}

module "vpn_connection" {
  source       = "../modules/pattern_vpn_connection"
  count        = (var.gateway && var.standalone_site != 0) ? var.standalone_site : 0
  location     = var.location
  gateway_1_id = module.hub_and_spoke.gateway_id
  gateway_2_id = module.standalone[count.index].gateway_id
  vault_psk    = true
  key_vault_id = module.hub_and_spoke.key_vault_id
}