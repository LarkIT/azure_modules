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


#resource "azurerm_route_table" "table" {
#  name                = "${var.environment}_${var.application_name}_routetable"
#  location            = "${var.location}"
#  resource_group_name = "${azurerm_resource_group.rg.name}"
#}

#resource "azurerm_route" "route" {
#  name                = "${var.environment}_${var.application_name}_route"
#  resource_group_name = "${azurerm_resource_group.rg.name}"
#  route_table_name    = "${azurerm_route_table.table.name}"
#  address_prefix      = "10.10.0.0/16"
#  next_hop_type       = "vnetlocal"
#}

resource "azurerm_subnet" "subnett" {
    name                 = "${var.environment}_${var.application_name}_subnet"
    resource_group_name  = "${azurerm_resource_group.rg.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    address_prefix       = "10.10.0.0/24"
}
