terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

locals {
  module_tags = tomap(
    {
      terraform-azurerm-composable-level2 = "pattern_spoke_jumphost"
    }
  )

  tags = merge(
    var.module_tags ? local.module_tags : {},
    var.tags
  )

  linux_virtual_machines = {
    for linux in module.linux_virtual_machine : linux.name => {
      admin_username            = linux.admin_username
      admin_password            = linux.admin_password
      source_image_reference_id = linux.source_image_reference_offer
      private_ip_address        = linux.private_ip_address
    }
  }

  windows_virtual_machines = {
    for windows in module.windows_virtual_machine : windows.name => {
      admin_username            = windows.admin_username
      admin_password            = windows.admin_password
      source_image_reference_id = windows.source_image_reference_offer
      private_ip_address        = windows.private_ip_address
    }
  }

  virtual_machines = merge(local.linux_virtual_machines, local.windows_virtual_machines)
}

data "http" "ipinfo" {
  url = "https://ifconfig.me"
  #data.http.ipinfo.response_body
}

module "resource_group" {
  source      = "../resource_group"
  location    = var.location
  environment = var.environment
  workload    = var.workload
  instance    = var.instance
  tags        = local.tags
}

module "virtual_network" {
  source              = "../virtual_network"
  location            = var.location
  environment         = var.environment
  workload            = var.workload
  instance            = var.instance
  resource_group_name = module.resource_group.name
  address_space       = var.address_space
  dns_servers         = var.dns_servers
  tags                = local.tags
}

module "subnet" {
  source               = "../subnet"
  location             = var.location
  environment          = var.environment
  workload             = var.workload
  instance             = var.instance
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.virtual_network.name
  address_prefixes     = var.address_space
}

module "routing" {
  source              = "../pattern_routing"
  count               = var.firewall ? 1 : 0
  location            = var.location
  environment         = var.environment
  workload            = var.workload
  instance            = var.instance
  resource_group_name = module.resource_group.name
  next_hop            = var.default_next_hop
  subnet_id           = module.subnet.id
  tags                = local.tags
}

module "linux_virtual_machine" {
  source              = "../linux_virtual_machine"
  count               = var.linux_virtual_machine ? 1 : 0
  location            = var.location
  environment         = var.environment
  workload            = var.workload
  instance            = var.instance
  resource_group_name = module.resource_group.name
  subnet_id           = module.subnet.id
  tags                = local.tags
}

module "windows_virtual_machine" {
  source              = "../windows_virtual_machine"
  count               = var.windows_virtual_machine ? 1 : 0
  location            = var.location
  environment         = var.environment
  workload            = var.workload
  instance            = var.instance
  resource_group_name = module.resource_group.name
  subnet_id           = module.subnet.id
  tags                = local.tags
}

resource "azurerm_firewall_policy_rule_collection_group" "this" {
  count              = var.firewall ? 1 : 0
  name               = "jumphost-rules"
  firewall_policy_id = var.firewall_policy_id
  priority           = 200

  nat_rule_collection {
    name     = "internet-to-jumphost"
    priority = 100
    action   = "Dnat"
    rule {
      name                = "internet-linuxjumphost-ssh"
      protocols           = ["TCP"]
      source_addresses    = [data.http.ipinfo.response_body]
      destination_address = var.firewall_public_ip
      destination_ports   = ["22"]
      translated_address  = module.linux_virtual_machine[0].private_ip_address
      translated_port     = "22"
    }
    rule {
      name                = "internet-windowsjumphost-rdp"
      protocols           = ["TCP"]
      source_addresses    = [data.http.ipinfo.response_body]
      destination_address = var.firewall_public_ip
      destination_ports   = ["3389"]
      translated_address  = module.windows_virtual_machine[0].private_ip_address
      translated_port     = "3389"
    }
  }

  network_rule_collection {
    name     = "jumphost-to-internal"
    priority = 200
    action   = "Allow"
    rule {
      name                  = "jumphost-internal-ssh"
      protocols             = ["TCP"]
      source_addresses      = [module.linux_virtual_machine[0].private_ip_address, module.windows_virtual_machine[0].private_ip_address]
      destination_addresses = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
      destination_ports     = ["22"]
    }
    rule {
      name                  = "jumphost-internal-rdp"
      protocols             = ["TCP"]
      source_addresses      = [module.linux_virtual_machine[0].private_ip_address, module.windows_virtual_machine[0].private_ip_address]
      destination_addresses = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
      destination_ports     = ["3389"]
    }
  }
}