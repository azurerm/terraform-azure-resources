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
      terraform-azurerm-module = "windows_virtual_machine"
    }
  )

  tags = merge(
    var.module_tags ? local.module_tags : {},
    var.workload != "" ? { workload = var.workload } : {},
    var.environment != "" ? { environment = var.environment } : {},
    var.tags
  )

  admin_password = coalesce(var.admin_password, try(random_password.this[0].result, ""))
}

module "locations" {
  source   = "../locations"
  location = var.location
}

module "naming" {
  source = "../naming"
  suffix = [var.workload, var.environment, var.instance]
}

resource "random_password" "this" {
  count            = var.admin_password == "" ? 1 : 0
  length           = var.random_password_length
  special          = true
  override_special = "_%@"
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
}

resource "azurerm_network_interface" "this" {
  name                           = coalesce(var.custom_network_interface_name, "${module.naming.windows_virtual_machine.name}-nic")
  location                       = var.location
  resource_group_name            = var.resource_group_name
  ip_forwarding_enabled          = var.enable_ip_forwarding
  accelerated_networking_enabled = var.enable_accelerated_networking
  ip_configuration {
    name                          = var.ip_configuration_name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.private_ip_address_allocation
    private_ip_address            = var.private_ip_address
  }
  tags = local.tags
}

resource "azurerm_windows_virtual_machine" "this" {
  name                                                   = coalesce(var.custom_name, module.naming.windows_virtual_machine.name)
  location                                               = var.location
  resource_group_name                                    = var.resource_group_name
  size                                                   = var.size
  zone                                                   = var.zone
  network_interface_ids                                  = [azurerm_network_interface.this.id]
  admin_username                                         = var.admin_username
  admin_password                                         = local.admin_password
  patch_mode                                             = var.patch_mode
  patch_assessment_mode                                  = var.patch_assessment_mode
  bypass_platform_safety_checks_on_user_schedule_enabled = var.patch_mode == "AutomaticByPlatform" ? true : false
  license_type                                           = var.license_type
  vm_agent_platform_updates_enabled                      = var.vm_agent_platform_updates_enabled
  boot_diagnostics {}
  os_disk {
    name                 = coalesce(var.custom_os_disk_name, "${module.naming.windows_virtual_machine.name}-dsk")
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_type
    disk_size_gb         = var.os_disk_size
  }
  source_image_reference {
    publisher = var.source_image_reference_publisher
    offer     = var.source_image_reference_offer
    sku       = var.source_image_reference_sku
    version   = var.source_image_reference_version
  }
  dynamic "identity" {
    for_each = var.identity_type != "None" ? [1] : []
    content {
      type         = var.identity_type
      identity_ids = var.identity_ids
    }
  }
  tags = local.tags
}

module "monitor_agent" {
  source                     = "../virtual_machine_extension"
  count                      = var.monitor_agent ? 1 : 0
  virtual_machine_id         = azurerm_windows_virtual_machine.this.id
  publisher                  = var.monitor_agent_publisher
  type                       = var.monitor_agent_type
  type_handler_version       = var.monitor_agent_type_handler_version
  automatic_upgrade_enabled  = var.monitor_agent_automatic_upgrade_enabled
  auto_upgrade_minor_version = var.monitor_agent_auto_upgrade_minor_version

  depends_on = [
    azurerm_windows_virtual_machine.this
  ]
}

module "dependency_agent" {
  source                     = "../virtual_machine_extension"
  count                      = var.monitor_agent ? 1 : 0
  virtual_machine_id         = azurerm_windows_virtual_machine.this.id
  publisher                  = var.dependency_agent_publisher
  type                       = var.dependency_agent_type
  type_handler_version       = var.dependency_agent_type_handler_version
  automatic_upgrade_enabled  = var.dependency_agent_automatic_upgrade_enabled
  auto_upgrade_minor_version = var.dependency_agent_auto_upgrade_minor_version
  time_sleep                 = "10s"
  settings = jsonencode(
    {
      "enableAMA" = "true"
    }
  )

  depends_on = [
    module.monitor_agent
  ]
}

module "watcher_agent" {
  source                     = "../virtual_machine_extension"
  count                      = var.watcher_agent ? 1 : 0
  virtual_machine_id         = azurerm_windows_virtual_machine.this.id
  publisher                  = var.watcher_agent_publisher
  type                       = var.watcher_agent_type
  type_handler_version       = var.watcher_agent_type_handler_version
  automatic_upgrade_enabled  = var.watcher_agent_automatic_upgrade_enabled
  auto_upgrade_minor_version = var.watcher_agent_auto_upgrade_minor_version

  depends_on = [
    azurerm_windows_virtual_machine.this
  ]
}

module "agents" {
  source                     = "../virtual_machine_extension"
  for_each                   = var.agents
  virtual_machine_id         = azurerm_windows_virtual_machine.this.id
  publisher                  = each.value.publisher
  type                       = each.value.type
  type_handler_version       = each.value.type_handler_version
  automatic_upgrade_enabled  = each.value.automatic_upgrade_enabled
  auto_upgrade_minor_version = each.value.auto_upgrade_minor_version
  settings                   = each.value.settings

  depends_on = [
    azurerm_windows_virtual_machine.this
  ]
}