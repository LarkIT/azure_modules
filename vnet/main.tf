#resource "azurerm_resource_group" "rg" {
#  name     = "${var.environment}_${var.application_name}_vnet_rg"
#  location = "${var.location}"
#}

locals {
  resource_group = "test_themis_vnet_rg"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.environment}_${var.application_name}_vnet"
  address_space       = ["${var.address_space}"]
  location            = "${var.location}"
  resource_group_name = "${local.resource_group}"
}

resource "azurerm_subnet" "test_dmz_subnet" {
    name                 = "${var.environment}_${var.application_name}_dmz_subnet"
    resource_group_name  = "${local.resource_group}"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    address_prefix       = "${var.network[ "test_dmz" ]}"
}

resource "azurerm_subnet" "test_app_subnet" {
    name                 = "${var.environment}_${var.application_name}_app_subnet"
    resource_group_name  = "${local.resource_group}"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    address_prefix       = "${var.network[ "test_app" ]}"
}

resource "azurerm_subnet" "test_db_subnet" {
    name                 = "${var.environment}_${var.application_name}_db_subnet"
    resource_group_name  = "${local.resource_group}"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    address_prefix       = "${var.network[ "test_db" ]}"
}
