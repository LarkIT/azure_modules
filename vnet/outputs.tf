#output "rg_name" {
#  value = "${azurerm_resource_group.rg.name}"
#}

output "rg_name" {
  value = "${local.resource_group}"
}

output "test_dmz_subnet_id" {
  value = "${azurerm_subnet.test_dmz_subnet.id}"
}

output "test_app_subnet_id" {
  value = "${azurerm_subnet.test_app_subnet.id}"
}

output "test_db_subnet_id" {
  value = "${azurerm_subnet.test_db_subnet.id}"
}
