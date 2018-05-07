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
    address_prefix       = "${var.network[ "test_dmz_subnet" ]}"
}

resource "azurerm_subnet" "test_app_subnet" {
    name                 = "${var.environment}_${var.application_name}_app_subnet"
    resource_group_name  = "${local.resource_group}"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    address_prefix       = "${var.network[ "test_app_subnet" ]}"
}

resource "azurerm_subnet" "test_db_subnet" {
    name                 = "${var.environment}_${var.application_name}_db_subnet"
    resource_group_name  = "${local.resource_group}"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    address_prefix       = "${var.network[ "test_db_subnet" ]}"
}

# Create Network Security Group and rule
#resource "azurerm_network_security_group" "ssh" {
#    name                = "myNetworkSecurityGroup"
#    location            = "${var.location}"
#    resource_group_name = "${local.resource_group}"
#
#    security_rule {
#        name                       = "SSH"
#        priority                   = 1001
#        direction                  = "Inbound"
#        access                     = "Allow"
#        protocol                   = "Tcp"
#        source_port_range          = "*"
#        destination_port_range     = "22"
#        source_address_prefix      = "*"
#        destination_address_prefix = "*"
#    }
#
#    tags {
#        environment = "Terraform Demo"
#    }
#}

