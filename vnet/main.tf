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


resource "azurerm_network_interface" "nic" {
    name                      = "myNIC"
    location                  = "${var.location}"
    resource_group_name       = "${azurerm_resource_group.rg.name}"
    network_security_group_id = "${azurerm_network_security_group.ssh.id}"

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = "${azurerm_subnet.subnet.id}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id          = "${azurerm_public_ip.public_ip.id}"
    }

    tags {
        environment = "Terraform Demo"
    }
}

resource "azurerm_virtual_machine" "myterraformvm" {
    name                  = "myVM"
    location              = "${var.location}"
    resource_group_name   = "${azurerm_resource_group.rg.name}"
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
        computer_name  = "myvm"
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
