resource "azurerm_public_ip" "lb_ip" {
  name                         = "test"
  location                     = "${var.location}"
  resource_group_name          = "${var.rg}"
  public_ip_address_allocation = "static"
  domain_name_label            = "${var.rg}"

  tags {
    environment = "staging"
  }
}
