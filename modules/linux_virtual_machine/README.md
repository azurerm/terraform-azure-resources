# azurerm_linux_virtual_machine
Manages a Linux Virtual Machine.

Usage: 
```
module "example" {
    source = ""
    name = "example"
    resource_group_name = "example"
    location = "westeurope"
    address_space = ["10.0.0.0/24"]
}
```

Azure documentation: https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview
Terraform documentation: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network