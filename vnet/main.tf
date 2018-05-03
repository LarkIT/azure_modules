resource "azurerm_resource_group" "rg" {
  name     = "${var.environment}_${var.application_name}_vnet_rg"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.environment}_${var.application_name}_vnet"
  address_space       = ["${var.address_space}"]
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
}


resource "azurerm_route_table" "table" {
  name                = "${var.environment}_${var.application_name}_routetable}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
}
