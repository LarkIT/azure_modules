# Create Network Security Group and rule
resource "azurerm_network_security_group" "rdp" {
  name                = "myNetworkSecurityGroup"
  location            = "${var.location}"
  resource_group_name = "${var.rg}"

  security_rule {
    name                       = "RDP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags {
    environment = "Terraform Demo"
  }
}

resource "azurerm_public_ip" "public_ip" {
  count                        = "${var.number_servers}"
  name                         = "${var.application_name}_${var.hostname}_public_ip_${count.index}"
  location                     = "${var.location}"
  resource_group_name          = "${var.rg}"
  public_ip_address_allocation = "dynamic"

  tags {
    environment = "Terraform Demo"
  }
}

resource "azurerm_network_interface" "nic" {
  count                     = "${var.number_servers}"
  name                      = "${var.application_name}_${var.hostname}_nic_${count.index}"
  location                  = "${var.location}"
  resource_group_name       = "${var.rg}"
  network_security_group_id = "${azurerm_network_security_group.rdp.id}"

  ip_configuration {
    name                          = "${var.application_name}_${var.hostname}_nic_config_${count.index}"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "dynamic"
#    public_ip_address_id          = "${azurerm_public_ip.public_ip.id}"
    public_ip_address_id          = "${element(azurerm_public_ip.public_ip.*.id, count.index)}"
  }

  tags {
    environment = "Terraform Demo"
  }
}

resource "azurerm_virtual_machine" "virtual_machine" {
  count                 = "${var.number_servers}"
  name                  = "${var.application_name}_${var.hostname}_vm_${count.index}"
  location              = "${var.location}"
  resource_group_name   = "${var.rg}"
#  network_interface_ids = ["${azurerm_network_interface.nic.id}"]
  network_interface_ids = ["${element(azurerm_network_interface.nic.*.id, count.index)}"]
  vm_size               = "Standard_DS1_v2"
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true
  
  storage_os_disk {
    name              = "${var.application_name}_${var.hostname}_osdisk_${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  os_profile {
    computer_name  = "${var.hostname}-${count.index}"
    admin_username = "azureuser"
    admin_password = "${var.admin_password}"
  }

  os_profile_windows_config {
    provision_vm_agent = false
  }

  tags {
    environment = "Terraform Demo"
  }
}
