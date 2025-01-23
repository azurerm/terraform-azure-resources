run "complete-hub_and_spoke" {
  command = plan

  variables {
    firewall_palo_alto      = true
    spoke_dns               = true
    address_space_spoke_dns = ["10.100.1.0/24"]
    spoke_dmz               = true
    address_space_spoke_dmz = ["10.100.2.0/24"]
  }
}