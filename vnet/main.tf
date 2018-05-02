resource "azurerm_resource_group" "rg" {
  name     = "${var.environment}_${var.application_name}_vnet_rg"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.environment}_${var.application_name}_vnet"
  address_space       = ["10.10.0.0/24"]
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
}


