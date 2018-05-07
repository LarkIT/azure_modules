output "rg_name" {
  value = "${azurerm_resource_group.rg.name}"
}

output "dmz_subnet_id" {
  value = "${azurerm_subnet.dmz_subnet.id}"
}

output "app_subnet_id" {
  value = "${azurerm_subnet.app_subnet.id}"
}

output "db_subnet_id" {
  value = "${azurerm_subnet.db_subnet.id}"
}
