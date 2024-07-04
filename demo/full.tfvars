private_monitoring                     = true
address_space_spoke_private_monitoring = ["10.100.3.0/27"]
connection_monitor                     = true
update_management                      = true
network_security_group                 = true
backup                                 = true
address_space_spokes_count             = 4
# address_space_spokes = [
#   {
#     workload      = "app1"
#     environment   = "dev"
#     instance      = "001"
#     address_space = ["10.100.10.0/24"]
#   },
#   {
#     workload      = "app1"
#     environment   = "prd"
#     instance      = "001"
#     address_space = ["10.100.110.0/24"]
#   },
#   {
#     workload      = "app2"
#     environment   = "dev"
#     instance      = "001"
#     address_space = ["10.100.11.0/24"]
#   },
#   {
#     workload      = "app2"
#     environment   = "prd"
#     instance      = "001"
#     address_space = ["10.100.111.0/24"]
#   }
# ]