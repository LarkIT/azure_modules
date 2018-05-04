output "rg_name" {
  value = "${azurerm_resource_group.rg.name}"
}
output "nic_id" {
  value = "${azurerm_network_interface.nic.id}"
}

output "subnet_id" {
  value = "${azurerm_subnet.subnet.id}"
}
