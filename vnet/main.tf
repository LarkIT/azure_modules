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

resource "azurerm_subnet" "subnet" {
    name                 = "${var.environment}_${var.application_name}_subnet"
    resource_group_name  = "${azurerm_resource_group.rg.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    address_prefix       = "10.10.0.0/24"
}

resource "azurerm_public_ip" "public_ip" {
    name                         = "myPublicIP"
    location                     = "${var.location}"
    resource_group_name          = "${azurerm_resource_group.rg.name}"
    public_ip_address_allocation = "dynamic"

    tags {
        environment = "Terraform Demo"
    }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "ssh" {
    name                = "myNetworkSecurityGroup"
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags {
        environment = "Terraform Demo"
    }
}


