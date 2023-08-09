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
      terraform-module-source = "azurerm/resources/azure//modules/linux_virtual_machine"
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
  source   = "azurerm/locations/azure"
  location = var.location
}

module "naming" {
  source = "azurerm/naming/azure"
  suffix = [var.workload, var.environment, module.locations.short_name, var.instance]
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
  name                          = coalesce(var.custom_network_interface_name, module.naming.network_interface.name)
  location                      = var.location
  resource_group_name           = var.resource_group_name
  enable_ip_forwarding          = var.enable_ip_forwarding
  enable_accelerated_networking = var.enable_accelerated_networking
  ip_configuration {
    name                          = var.ip_configuration_name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.private_ip_address_allocation
  }
  tags = local.tags
}

resource "azurerm_linux_virtual_machine" "this" {
  name                            = coalesce(var.custom_name, module.naming.linux_virtual_machine.name)
  location                        = var.location
  resource_group_name             = var.resource_group_name
  size                            = var.size
  zone                            = var.zone
  network_interface_ids           = [azurerm_network_interface.this.id]
  admin_username                  = var.admin_username
  disable_password_authentication = false
  admin_password                  = local.admin_password
  boot_diagnostics {}
  os_disk {
    name                 = coalesce(var.custom_os_disk_name, module.naming.managed_disk.name)
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
  custom_data = var.run_bootstrap == true ? coalesce(var.custom_data, base64encode("${path.module}/cloud-init.txt")) : null
  tags        = local.tags
}
