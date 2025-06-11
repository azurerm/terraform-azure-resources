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
      terraform-azurerm-composable-level2 = "pattern_hub"
    }
  )

  tags = merge(
    var.module_tags ? local.module_tags : {},
    var.tags
  )

  access_policy_object_ids = concat([data.azurerm_client_config.current.object_id, module.user_assigned_identity.uuid], var.additional_access_policy_object_ids)
}

data "azurerm_client_config" "current" {}

data "http" "ipinfo" {
  count = var.ip_filter ? 1 : 0
  url   = "https://ifconfig.me/ip"
  #data.http.ipinfo[0].response_body
}

module "resource_group" {
  source      = "../resource_group"
  location    = var.location
  environment = var.environment
  workload    = var.workload
  instance    = var.instance
  tags        = local.tags
}

module "resource_group_management" {
  source      = "../resource_group"
  location    = var.location
  environment = var.environment
  workload    = var.workload_management
  instance    = var.instance
  tags        = local.tags
}

module "log_analytics_workspace" {
  source              = "../log_analytics_workspace"
  location            = var.location
  environment         = var.environment
  workload            = var.workload_management
  instance            = var.instance
  resource_group_name = module.resource_group_management.name
  tags                = local.tags
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

module "subnet_gateway" {
  source               = "../subnet"
  count                = var.gateway ? 1 : 0
  location             = var.location
  custom_name          = "GatewaySubnet"
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.virtual_network.name
  address_prefixes     = [cidrsubnet(var.address_space[0], 2, 0)]
}

module "public_ip_gateway" {
  source              = "../public_ip"
  count               = var.gateway ? var.p2s_vpn ? 3 : 2 : 0
  location            = var.location
  environment         = var.environment
  workload            = "gw"
  instance            = "00${count.index + 1}"
  resource_group_name = module.resource_group.name
  tags                = local.tags
}

module "gateway" {
  source              = "../virtual_network_gateway"
  count               = var.gateway ? 1 : 0
  location            = var.location
  environment         = var.environment
  workload            = var.workload
  instance            = var.instance
  resource_group_name = module.resource_group.name
  type                = var.gateway_type
  sku                 = var.gateway_sku
  asn                 = var.asn
  active_active       = true
  p2s_vpn             = var.p2s_vpn
  ip_configurations = [for index, pip in module.public_ip_gateway : {
    name                 = "ipconfig${index + 1}"
    public_ip_address_id = pip.id
    subnet_id            = module.subnet_gateway[0].id
  }]
  tags = local.tags
}

module "gateway_diagnostic_setting" {
  source                     = "../monitor_diagnostic_setting"
  count                      = var.gateway ? 1 : 0
  target_resource_id         = module.gateway[0].id
  log_analytics_workspace_id = module.log_analytics_workspace.id
}

module "route_table_gateway" {
  source              = "../route_table"
  count               = (var.gateway && var.firewall) ? 1 : 0
  location            = var.location
  environment         = var.environment
  workload            = "gw"
  instance            = var.instance
  resource_group_name = module.resource_group.name
  tags                = local.tags
}

module "subnet_route_table_association_gateway" {
  source         = "../subnet_route_table_association"
  count          = (var.gateway && var.firewall) ? 1 : 0
  subnet_id      = module.subnet_gateway[0].id
  route_table_id = module.route_table_gateway[0].id

  depends_on = [
    module.gateway
  ]
}

module "subnet_firewall" {
  source               = "../subnet"
  count                = (var.firewall && !var.firewall_palo_alto) ? 1 : 0
  location             = var.location
  custom_name          = "AzureFirewallSubnet"
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.virtual_network.name
  address_prefixes     = [cidrsubnet(var.address_space[0], 2, 1)]
}

module "locations" {
  source   = "../locations"
  count    = var.firewall_palo_alto ? 1 : 0
  location = var.location
}

resource "random_integer" "this" {
  count = var.firewall_palo_alto ? 1 : 0
  min   = 1000
  max   = 9999
}

module "firewall_palo_alto" {
  source                = "../firewall_palo_alto"
  count                 = var.firewall_palo_alto ? 1 : 0
  region                = var.location
  resource_group_name   = module.resource_group.name
  create_resource_group = false

  vnets = {
    "hub" = {
      name                   = module.virtual_network.name
      resource_group_name    = module.virtual_network.resource_group_name
      create_virtual_network = false
      network_security_groups = {
        "management" = {
          name = "nsg-fw-mgmt-${module.locations[0].short_name}-001"
          rules = {
            mgmt_inbound = {
              name                       = "A-IN-SourceIP-Net10-Admin"
              priority                   = 100
              direction                  = "Inbound"
              access                     = "Allow"
              protocol                   = "Tcp"
              source_address_prefixes    = [var.ip_filter ? data.http.ipinfo[0].response_body : "0.0.0.0/0"]
              source_port_range          = "*"
              destination_address_prefix = "10.0.0.0/8"
              destination_port_ranges    = ["22", "443"]
            }
          }
        }
        "public" = {
          name = "nsg-fw-pub-${module.locations[0].short_name}-001"
        }
      }
      route_tables = {
        "management" = {
          name = "rt-fw-mgmt-${module.locations[0].short_name}-001"
          routes = {
            "public_blackhole" = {
              name           = "public-blackhole"
              address_prefix = cidrsubnet(var.address_space[0], 4, 5)
              next_hop_type  = "None"
            }
            "private_blackhole" = {
              name           = "private-blackhole"
              address_prefix = cidrsubnet(var.address_space[0], 4, 6)
              next_hop_type  = "None"
            }
          }
        }
        "public" = {
          name = "rt-fw-pub-${module.locations[0].short_name}-001"
          routes = {
            "mgmt_blackhole" = {
              name           = "mgmt-blackhole"
              address_prefix = cidrsubnet(var.address_space[0], 4, 4)
              next_hop_type  = "None"
            }
            "private_blackhole" = {
              name           = "private-blackhole"
              address_prefix = cidrsubnet(var.address_space[0], 4, 6)
              next_hop_type  = "None"
            }
          }
        }
        "private" = {
          name = "rt-fw-priv-${module.locations[0].short_name}-001"
          routes = {
            "default" = {
              name                = "default"
              address_prefix      = "0.0.0.0/0"
              next_hop_type       = "VirtualAppliance"
              next_hop_ip_address = cidrhost(cidrsubnet(var.address_space[0], 4, 6), 4)
            }
            "mgmt_blackhole" = {
              name           = "mgmt-blackhole"
              address_prefix = cidrsubnet(var.address_space[0], 4, 4)
              next_hop_type  = "None"
            }
            "public_blackhole" = {
              name           = "public-blackhole"
              address_prefix = cidrsubnet(var.address_space[0], 4, 5)
              next_hop_type  = "None"
            }
          }
        }
      }
      subnets = {
        "management" = {
          name                            = "snet-fw-mgmt-001"
          address_prefixes                = [cidrsubnet(var.address_space[0], 4, 4)]
          network_security_group_key      = "management"
          route_table_key                 = "management"
          enable_storage_service_endpoint = true
        }
        "public" = {
          name                       = "snet-fw-pub-001"
          address_prefixes           = [cidrsubnet(var.address_space[0], 4, 5)]
          network_security_group_key = "public"
          route_table_key            = "public"
        }
        "private" = {
          name             = "snet-fw-priv-001"
          address_prefixes = [cidrsubnet(var.address_space[0], 4, 6)]
          route_table_key  = "private"
        }
      }
    }
  }

  load_balancers = {
    "public" = {
      name = "elb-hub-prd-${module.locations[0].short_name}-001"
      nsg_auto_rules_settings = {
        nsg_vnet_key = "hub"
        nsg_key      = "public"
        source_ips   = [var.ip_filter ? data.http.ipinfo[0].response_body : "0.0.0.0/0"]
      }
      frontend_ips = {
        "app1" = {
          name             = "front-fw-pub-${module.locations[0].short_name}-001"
          public_ip_name   = "pip-elb-prd-${module.locations[0].short_name}-001"
          create_public_ip = true
          in_rules = {
            "balanceHttp" = {
              name     = "HTTP"
              protocol = "Tcp"
              port     = 80
            }
          }
        }
      }
    }
    "private" = {
      name     = "ilb-hub-prd-${module.locations[0].short_name}-001"
      vnet_key = "hub"
      frontend_ips = {
        "ha-ports" = {
          name               = "front-fw-priv-${module.locations[0].short_name}-001"
          subnet_key         = "private"
          private_ip_address = cidrhost(cidrsubnet(var.address_space[0], 4, 6), 4)
          in_rules = {
            HA_PORTS = {
              name     = "HA-ports"
              port     = 0
              protocol = "All"
            }
          }
        }
      }
    }
  }

  natgws = {
    "natgw" = {
      name        = "nat-hub-prd-${module.locations[0].short_name}-001"
      vnet_key    = "hub"
      subnet_keys = ["public"]
      public_ip = {
        create = true
        name   = "pip-nat-prd-${module.locations[0].short_name}-001"
      }
    }
  }

  vmseries_universal = {
    version = "latest"
    size    = "Standard_DS3_v2"
  }

  bootstrap_storages = {
    "bootstrap" = {
      name = "safwbtstrp${random_integer.this[0].result}"
      storage_network_security = {
        vnet_key            = "hub"
        allowed_subnet_keys = ["management"]
        allowed_public_ips  = [var.ip_filter ? data.http.ipinfo[0].response_body : "0.0.0.0/0"]
      }
    }
  }

  vmseries = {
    "fw-1" = {
      name     = "fw-hub-prd-${module.locations[0].short_name}-001"
      vnet_key = "hub"
      virtual_machine = {
        zone      = 1
        disk_name = "fw-hub-prd-${module.locations[0].short_name}-001-dsk"
        bootstrap_package = {
          bootstrap_storage_key  = "bootstrap"
          static_files           = { "${path.module}/../firewall_palo_alto/files/init-cfg.txt" = "config/init-cfg.txt" }
          bootstrap_xml_template = "${path.module}/../firewall_palo_alto/templates/bootstrap_common.tmpl"
          private_snet_key       = "private"
          public_snet_key        = "public"
          intranet_cidr          = "10.0.0.0/8"
        }
      }
      interfaces = [
        {
          name             = "fw-hub-prd-${module.locations[0].short_name}-001-mgmt"
          subnet_key       = "management"
          create_public_ip = true
        },
        {
          name                    = "fw-hub-prd-${module.locations[0].short_name}-001-pub"
          subnet_key              = "public"
          create_public_ip        = false
          load_balancer_key       = "public"
          application_gateway_key = "public"
        },
        {
          name              = "fw-hub-prd-${module.locations[0].short_name}-001-priv"
          subnet_key        = "private"
          load_balancer_key = "private"
        }
      ]
    }
    "fw-2" = {
      name     = "fw-hub-prd-${module.locations[0].short_name}-002"
      vnet_key = "hub"
      virtual_machine = {
        zone      = 2
        disk_name = "fw-hub-prd-${module.locations[0].short_name}-002-dsk"
        bootstrap_package = {
          bootstrap_storage_key  = "bootstrap"
          static_files           = { "${path.module}/../firewall_palo_alto/files/init-cfg.txt" = "config/init-cfg.txt" }
          bootstrap_xml_template = "${path.module}/../firewall_palo_alto/templates/bootstrap_common.tmpl"
          private_snet_key       = "private"
          public_snet_key        = "public"
          intranet_cidr          = "10.0.0.0/8"
        }
      }
      interfaces = [
        {
          name             = "fw-hub-prd-${module.locations[0].short_name}-002-mgmt"
          subnet_key       = "management"
          create_public_ip = true
        },
        {
          name                    = "fw-hub-prd-${module.locations[0].short_name}-002-pub"
          subnet_key              = "public"
          create_public_ip        = false
          load_balancer_key       = "public"
          application_gateway_key = "public"
        },
        {
          name              = "fw-hub-prd-${module.locations[0].short_name}-002-priv"
          subnet_key        = "private"
          load_balancer_key = "private"
        },
      ]
    }
  }
  depends_on = [module.virtual_network]
}

module "public_ip_firewall" {
  source              = "../public_ip"
  count               = (var.firewall && !var.firewall_palo_alto) ? 1 : 0
  location            = var.location
  environment         = var.environment
  workload            = "fw"
  instance            = var.instance
  resource_group_name = module.resource_group.name
  tags                = local.tags
}

module "firewall_policy" {
  source              = "../firewall_policy"
  count               = (var.firewall && !var.firewall_palo_alto) ? 1 : 0
  location            = var.location
  environment         = var.environment
  workload            = var.workload
  instance            = var.instance
  resource_group_name = module.resource_group.name
  sku                 = var.firewall_sku
  dns_servers         = var.dns_servers
  dns_proxy_enabled   = var.dns_servers != [] ? true : false
  tags                = local.tags
}

module "firewall" {
  source                     = "../firewall"
  count                      = (var.firewall && !var.firewall_palo_alto) ? 1 : 0
  location                   = var.location
  environment                = var.environment
  workload                   = var.workload
  instance                   = var.instance
  resource_group_name        = module.resource_group.name
  firewall_policy_id         = module.firewall_policy[0].id
  public_ip_address_id       = module.public_ip_firewall[0].id
  subnet_id                  = module.subnet_firewall[0].id
  log_analytics_workspace_id = module.log_analytics_workspace.id
  sku_tier                   = var.firewall_sku
  tags                       = local.tags
}

module "firewall_diagnostic_setting" {
  source                     = "../monitor_diagnostic_setting"
  count                      = (var.firewall && !var.firewall_palo_alto) ? 1 : 0
  target_resource_id         = module.firewall[0].id
  log_analytics_workspace_id = module.log_analytics_workspace.id
}

module "firewall_workbook" {
  source              = "../firewall_workbook"
  count               = (var.firewall && !var.firewall_palo_alto) ? 1 : 0
  location            = var.location
  resource_group_name = module.resource_group.name
  tags                = local.tags
}

resource "azurerm_firewall_policy_rule_collection_group" "this" {
  count              = (var.firewall && !var.firewall_palo_alto && var.firewall_default_rules) ? 1 : 0
  name               = "default-rules"
  firewall_policy_id = module.firewall_policy[0].id
  priority           = 100

  network_rule_collection {
    name     = "internal"
    priority = 100
    action   = "Allow"
    rule {
      name                  = "private-private-any"
      protocols             = ["TCP", "UDP", "ICMP"]
      source_addresses      = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
      destination_addresses = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
      destination_ports     = ["*"]
    }
  }
  network_rule_collection {
    name     = "web"
    priority = 200
    action   = "Allow"
    rule {
      name                  = "private-internet-web"
      protocols             = ["TCP"]
      source_addresses      = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
      destination_addresses = ["*"]
      destination_ports     = ["80", "443"]
    }
  }
  network_rule_collection {
    name     = "admin"
    priority = 300
    action   = "Allow"
    rule {
      name                  = "private-azure-kms"
      protocols             = ["TCP"]
      source_addresses      = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
      destination_addresses = ["20.118.99.224", "40.83.235.53"]
      destination_ports     = ["1688"]
    }
    rule {
      name                  = "private-azure-ntp"
      protocols             = ["UDP"]
      source_addresses      = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
      destination_addresses = ["51.145.123.29"]
      destination_ports     = ["123"]
    }
  }
}

module "subnet_bastion" {
  source               = "../subnet"
  count                = var.bastion ? 1 : 0
  location             = var.location
  custom_name          = "AzureBastionSubnet"
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.virtual_network.name
  address_prefixes     = [cidrsubnet(var.address_space[0], 2, 2)]
}

module "public_ip_bastion" {
  source              = "../public_ip"
  count               = var.bastion ? 1 : 0
  location            = var.location
  environment         = var.environment
  workload            = "bas"
  instance            = var.instance
  resource_group_name = module.resource_group.name
  tags                = local.tags
}

module "bastion" {
  source               = "../bastion_host"
  count                = var.bastion ? 1 : 0
  location             = var.location
  environment          = var.environment
  workload             = var.workload
  instance             = var.instance
  resource_group_name  = module.resource_group.name
  public_ip_address_id = module.public_ip_bastion[0].id
  subnet_id            = module.subnet_bastion[0].id
  sku                  = var.bastion_sku
  tags                 = local.tags
}

module "bastion_diagnostic_setting" {
  source                     = "../monitor_diagnostic_setting"
  count                      = var.bastion ? 1 : 0
  target_resource_id         = module.bastion[0].id
  log_analytics_workspace_id = module.log_analytics_workspace.id
}

module "user_assigned_identity" {
  source              = "../user_assigned_identity"
  location            = var.location
  environment         = var.environment
  workload            = var.workload_management
  instance            = var.instance
  resource_group_name = module.resource_group_management.name
  tags                = local.tags
}

module "key_vault" {
  source              = "../key_vault"
  count               = var.key_vault ? 1 : 0
  tenant_id           = data.azurerm_client_config.current.tenant_id
  location            = var.location
  environment         = var.environment
  workload            = var.workload_management
  instance            = var.instance
  resource_group_name = module.resource_group_management.name
  access_policy = [for id in local.access_policy_object_ids : {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = id
    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "Purge"
    ]
    key_permissions = []
    certificate_permissions = [
      "Get",
      "List",
      "Update",
      "Create",
      "Import",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "ManageContacts",
      "ManageIssuers",
      "GetIssuers",
      "ListIssuers",
      "SetIssuers",
      "DeleteIssuers",
      "Purge"
    ]
    storage_permissions = []
  }]
  network_acls = [
    {
      bypass                     = "AzureServices"
      default_action             = var.ip_filter ? "Deny" : "Allow"
      ip_rules                   = var.ip_filter ? [data.http.ipinfo[0].response_body] : []
      virtual_network_subnet_ids = []
    }
  ]
  tags = local.tags
}

module "key_vault_diagnostic_setting" {
  source                     = "../monitor_diagnostic_setting"
  count                      = var.key_vault ? 1 : 0
  target_resource_id         = module.key_vault[0].id
  log_analytics_workspace_id = module.log_analytics_workspace.id
}

module "storage_account" {
  count                        = var.storage_account ? 1 : 0
  source                       = "../storage_account"
  location                     = var.location
  environment                  = var.environment
  workload                     = var.workload_management
  resource_group_name          = module.resource_group_management.name
  network_rules_default_action = var.ip_filter ? "Deny" : "Allow"
  network_rules_bypass         = ["AzureServices"]
  network_rules_ip_rules       = var.ip_filter ? [data.http.ipinfo[0].response_body] : []
  tags                         = local.tags
}

# module "storage_account_diagnostic_setting" {
#   source                     = "../monitor_diagnostic_setting"
#   count                      = var.storage_account ? 1 : 0
#   target_resource_id         = module.storage_account[0].id
#   log_analytics_workspace_id = module.log_analytics_workspace.id
# }