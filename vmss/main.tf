resource "azurerm_public_ip" "lb_ip" {
  name                         = "test"
  location                     = "${var.location}"
  resource_group_name          = "${var.resource_group}"
  public_ip_address_allocation = "static"
  domain_name_label            = "test-themis-vnet-rg"

  tags {
    environment = "staging"
  }
}
