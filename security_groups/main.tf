resource "azurerm_network_security_group" "windows" {
  name                = "myNetworkSecurityGroup"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"
}

#resource "azurerm_network_security_group" "ssl" {
#  name                = "myNetworkSecurityGroup"
#  location            = "${var.location}"
#}

#resource "azurerm_network_security_group" "ftp" {
#  name                = "myNetworkSecurityGroup"
#  location            = "${var.location}"
#  resource_group_name = "${var.resource_group}"
#}


resource "azurerm_network_security_rule" "winrm" {
  name                        = "winrm"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "5986"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.resource_group}"
  network_security_group_name = "${azurerm_network_security_group.windows.name}"
}
