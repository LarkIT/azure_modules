resource "azurerm_resource_group" "rg" {
  name     = "themis_nonProd_vnet_rg"
  location = "centralus"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "Vnet123"
  address_space       = ["10.10.0.0/24"]
  location            = "centralus"
  resource_group_name = "${azurerm_resource_group.rg.name}"
}


