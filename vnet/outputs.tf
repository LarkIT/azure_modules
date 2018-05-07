output "rg_name" {
  value = "${azurerm_resource_group.rg.name}"
}

output "test_dmz_subnet_id" {
  value = "${azurerm_subnet.dmz_subnet.id}"
}

output "test_app_subnet_id" {
  value = "${azurerm_subnet.app_subnet.id}"
}

output "test_db_subnet_id" {
  value = "${azurerm_subnet.db_subnet.id}"
}
