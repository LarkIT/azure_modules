resource "azurerm_public_ip" "public_ip" {
  name                         = "${var.environment}_${var.application_name}_public_ip"
  location                     = "${var.location}"
  resource_group_name          = "${var.resource_group}"
  public_ip_address_allocation = "static"
  domain_name_label            = "${var.environment}-${var.application_name}-vnet-rg"

  tags {
    environment = "staging"
  }
}

resource "azurerm_lb" "loadbalancer" {
  name                = "${var.environment}_${var.application_name}_loadbalancer"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = "${azurerm_public_ip.public_ip.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
  name                = "BackEndAddressPool"
  resource_group_name = "${var.resource_group}"
  loadbalancer_id     = "${azurerm_lb.loadbalancer.id}"
}

resource "azurerm_lb_nat_pool" "lbnatpool" {
  count                          = 3
  name                           = "ssh"
  resource_group_name            = "${var.resource_group}"
  loadbalancer_id                = "${azurerm_lb.loadbalancer.id}"
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50119
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPAddress"
}

resource "azurerm_virtual_machine_scale_set" "test" {
  name                = "${var.environment}_${var.application_name}_vmss"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"
  upgrade_policy_mode = "Manual"

  sku {
    name     = "Standard_A0"
    tier     = "Standard"
    capacity = 2
  }

  storage_profile_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_profile_data_disk {
    lun            = 0
    caching        = "ReadWrite"
    create_option  = "Empty"
    disk_size_gb   = 10
  }

  os_profile {
    computer_name_prefix = "testvm"
    admin_username       = "${var.admin_username}"
    admin_password       = "Passwword1234"
  }

  os_profile_windows_config {
    provision_vm_agent = false
  }

  network_profile {
    name    = "terraformnetworkprofile"
    primary = true

    ip_configuration {
      name                                   = "TestIPConfiguration"
      subnet_id                              = "${var.subnet_id}"
      load_balancer_backend_address_pool_ids = ["${azurerm_lb_backend_address_pool.bpepool.id}"]
      load_balancer_inbound_nat_rules_ids    = ["${element(azurerm_lb_nat_pool.lbnatpool.*.id, count.index)}"]
    }
  }

  tags {
    environment = "staging"
  }
}
