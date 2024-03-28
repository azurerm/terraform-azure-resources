run "complete-hub_and_spoke" {
  command = plan

  module {
    source = "./tests/setup"
  }

  variables {
    firewall                               = true
    gateway                                = true
    bastion                                = true
    spoke_dns                              = true
    address_space_spoke_dns                = ["10.100.1.0/24"]
    spoke_dmz                              = true
    address_space_spoke_dmz                = ["10.100.2.0/24"]
    private_monitoring                     = true
    address_space_spoke_private_monitoring = ["10.100.3.0/27"]
    connection_monitor                     = true
    update_management                      = true
    network_security_group                 = true
    backup                                 = true
  }
}