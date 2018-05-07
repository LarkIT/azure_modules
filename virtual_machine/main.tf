# Create Network Security Group and rule
resource "azurerm_network_security_group" "ssh" {
  name                = "myNetworkSecurityGroup"
  location            = "${var.location}"
  resource_group_name = "${var.rg}"

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

resource "azurerm_public_ip" "public_ip" {
  count                        = "${var.number_servers}"
  name                         = "${var.environment}_${var.application_name}_public_ip_${count.index}"
  location                     = "${var.location}"
  resource_group_name          = "${var.rg}"
  public_ip_address_allocation = "dynamic"

  tags {
    environment = "Terraform Demo"
  }
}

resource "azurerm_network_interface" "nic" {
  count                     = "${var.number_servers}"
  name                      = "${var.environment}_${var.application_name}_nic_${count.index}"
  location                  = "${var.location}"
  resource_group_name       = "${var.rg}"
  network_security_group_id = "${azurerm_network_security_group.ssh.id}"

  ip_configuration {
    name                          = "${var.environment}_${var.application_name}_nic_config_${count.index}"
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
  name                  = "${var.environment}_${var.application_name}_vm_${count.index}"
  location              = "${var.location}"
  resource_group_name   = "${var.rg}"
  network_interface_ids = ["${azurerm_network_interface.nic.id}"]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "${var.environment}_${var.application_name}_osdisk_${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "${var.hostname}-${count.index}"
    admin_username = "azureuser"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/azureuser/.ssh/authorized_keys"
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDKSFLdyC/e/IjDweZY9Me7WReCkeKDU46f8PFrIbQ5SsDVsyVKaPiocaD+ntibNHTdDdKbXpVT5IZuadG0tJ2zTae+w5oloBal0jg8ZE0Y/kyN96+W0S0x3uuxHJiBXBLmDtXW1maHbVu/aApT9uzdkk5nCdgy4pLp/TrTZ4LTEDDRGwdwZRGjey1ZgcW2yIvIQ1uciGWwN4hm86jswtCBnMbIeBLPkOmoC5jJ5TX64h48TPUbL8QXpuIPjtb1OznO1OWvATqdNYIfuR0baEf93pbC4XwvzWOn6PxivuAzeS2FUzSe3e7FUOJj9bF/L8DOrHFadcXkYcv7NiQ570aH"
    }
  }

  #    boot_diagnostics {
  #        enabled = "true"
  #        storage_uri = "${azurerm_storage_account.mystorageaccount.primary_blob_endpoint}"
  #    }

  tags {
    environment = "Terraform Demo"
  }
}
