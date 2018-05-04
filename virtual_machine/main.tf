resource "azurerm_public_ip" "public_ip" {
    name                         = "myPublicIP"
    location                     = "${var.location}"
    resource_group_name          = "${var.rg}"
    public_ip_address_allocation = "dynamic"

    tags {
        environment = "Terraform Demo"
    }
}

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


resource "azurerm_network_interface" "nic" {
    name                      = "myNIC"
    location                  = "${var.location}"
    resource_group_name       = "${var.rg}"
    network_security_group_id = "${azurerm_network_security_group.ssh.id}"

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = "${var.subnet_id}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id          = "${azurerm_public_ip.public_ip.id}"
    }

    tags {
        environment = "Terraform Demo"
    }
}

resource "azurerm_virtual_machine" "virtual_machine" {
    name                  = "myVM"
    location              = "${var.location}"
    resource_group_name   = "${var.rg}"
    network_interface_ids = ["${azurerm_network_interface.nic.id}"]
    vm_size               = "Standard_DS1_v2"

    storage_os_disk {
        name              = "myOsDisk"
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
        computer_name  = "${var.hostname}"
        admin_username = "azureuser"
    }

    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path     = "/home/azureuser/.ssh/authorized_keys"
            key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDMO/XWbgcN6gBtGPCbe9zEuQ3pA8NEQbqwDp6u88ACZ6NhRllvn3Vn/jbgbByB14wKpoeXmAvk3m6QUdxgV/CL4ab+YTuOeLbTUukxxUBW4bXtZk7XH1PCyChL/PaKRgdvjZEP7WJHyUx2o2kA/OgzNkMlJ4P+iBqc9svvOutviuRs4TGXvbDpedpZz85wyThRAMOo4WSQiyhhVtyoyqWP+jpgll/RycVBPUWxeyV3cuOMJfjsMjBRmfMilCp1Wlvmy2DCzOtHC3Ajmw3dTy1tjWbCMfw3/CWv8l09x3g43H0MytIhVZnzyQCfMOLuxPIOK7ezckblSqNic1q8L7/v"
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
