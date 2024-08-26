<!-- BEGIN_TF_DOCS -->
# Terraform Azure Resources
[![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurerm/resources/azure/latest/)

## Overview

This set of terraform modules will help you to create and manage a Azure Resources.

It can help you to create a Azure Resources with a simple way. 
Resources are available in the [Terraform Registry](https://registry.terraform.io/modules/azurerm/resources/azure/latest/).

Unit modules are available in the [modules](modules) directory based on the resource name.  
Composable/pattern modules are available in the [modules](modules) directory with pattern prefix.

The main goal of this set was to deploy a full Hub and Spoke architecture based on best practices and my own experience. Naming of the resource is based on [Azure naming convention](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming).

The gouvernance is not managed (yet) by this set of modules.

![Azure Hub & Spoke Global design](images/hub-and-spoke-global.png)

Depending of your needs, you can include or not the following resources:
- [Virtual Network Gateway](https://docs.microsoft.com/en-us/azure/vpn-gateway/) to connect to on-premise network
- [Azure Firewall](https://docs.microsoft.com/en-us/azure/firewall/) to control network traffic
- [Azure Bastion](https://docs.microsoft.com/en-us/azure/bastion/) to access to Virtual Machine
- [Azure Application Gateway](https://docs.microsoft.com/en-us/azure/application-gateway/) to expose web application
- [Azure Private DNS Resolver](https://learn.microsoft.com/en-us/azure/dns/dns-private-resolver-overview)
- [Spoke Jump Host](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/jumphost) accessible from the Internet through Azure Firewall
- [Spokes](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/hub-spoke) with [Virtual Machine](https://docs.microsoft.com/en-us/azure/virtual-machines/)
- [Key Vault](https://docs.microsoft.com/en-us/azure/key-vault/) to store secrets (passwords, certificates, ...)

## Limitations

- Single subscription
- No vWAN (Virtual WAN) support
- No gouvernance (Azure Policy, ...)
- No Network Security Group (NSG), security rules are managed by Azure Firewall
- All logs and all metrics are sent to Log Analytics Workspace

## Terraform modules

![Terraform modules](images/terraform-modules.png)
You can find all modules in the [modules](modules) directory.
One example is available below.

## Network design

The network design is based on [Hub and Spoke](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/hub-spoke) architecture. Routing is managed by [User Defined Route](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-udr-overview) (UDR) and [Azure Firewall](https://docs.microsoft.com/en-us/azure/firewall/overview).

![Network design](images/network-design.png)

## Example

```hcl
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "hub_and_spoke" {
  source                                 = "azurerm/resources/azure//modules/pattern_hub_and_spoke"
  location                               = "francecentral"
  firewall                               = true
  gateway                                = true
  bastion                                = true
  address_space_hub                      = ["10.100.0.0/24"]
  spoke_dns                              = true
  address_space_spoke_dns                = ["10.100.1.0/24"]
  spoke_dmz                              = true
  address_space_spoke_dmz                = ["10.100.2.0/24"]
  web_application_firewall               = true
  private_monitoring                     = true
  address_space_spoke_private_monitoring = ["10.100.3.0/27"]
  connection_monitor                     = true
  update_management                      = true
  address_space_spokes = [
    {
      workload        = "shared"
      environment     = "prd"
      instance        = "001"
      address_space   = ["10.100.5.0/24"]
      virtual_machine = false
    },
    {
      workload        = "app1"
      environment     = "dev"
      instance        = "001"
      address_space   = ["10.100.10.0/24"]
      virtual_machine = true
    }
  ]
}
```

## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->