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

  admin_password = var.admin_password == "" ? random_password.this[0].result : var.admin_password
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
  name                          = coalesce(var.custom_network_interface_name, "${module.naming.windows_virtual_machine.name}-nic")
  location                      = var.location
  resource_group_name           = var.resource_group_name
  enable_ip_forwarding          = var.enable_ip_forwarding
  enable_accelerated_networking = var.enable_accelerated_networking
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
    for_each = var.identity_type == "SystemAssigned" ? [1] : []
    content {
      type         = var.identity_type
      identity_ids = var.identity_ids
    }
  }
  tags = local.tags
}
