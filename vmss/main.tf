resource "azurerm_public_ip" "public_ip" {
  name                         = "test"
  location                     = "${var.location}"
  resource_group_name          = "${var.resource_group}"
  public_ip_address_allocation = "static"
  domain_name_label            = "test-themis-vnet-rg"

  tags {
    environment = "staging"
  }
}

resource "azurerm_lb" "loadbalancer" {
  name                = "${var.application_name}_loadbalancer"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = "${azurerm_public_ip.public_ip.id}"
  }
}
