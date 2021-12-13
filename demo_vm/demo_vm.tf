terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.86.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = "6c903494-a6a9-4bb5-80ad-a6b1816c67b3"
  client_id       = "a62210da-21dd-4d81-8c10-d6fe69cba69b"
  client_secret   = "HWu7Q~LI1qAbuaIUtj6SDE62skBbIzM4RdhCx"
  tenant_id       = "a66d2e30-7919-43a0-8b5d-a355f1e2e08d"
}

variable "prefix" {
  type    = string
  default = "trainer"
}

variable "location" {
  type    = string
  default = "centralus"
}

resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-resources"
  location = var.location
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes       = ["10.0.2.0/24"]
}


resource "azurerm_public_ip" "main" {
  name                = "${var.prefix}-pip"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  resource_group_name   = azurerm_resource_group.main.name
  location              = azurerm_resource_group.main.location
  size               = "Standard_D4s_v3"
  network_interface_ids = [azurerm_network_interface.main.id]
  delete_os_disk_on_termination = false

  admin_username                  = "adminuser"
  admin_password                  = "P@ssw0rd1234!"
  disable_password_authentication = false

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "Gen2"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
    # delete_os_disk_on_termination   = false
  }

  # provisioner "remote-exec" {
  #   inline = [
  #     "touch test.out",

  #   ]

  #   connection {
  #     host     = self.public_ip_address
  #     user     = self.admin_username
  #     password = self.admin_password
  #   }
  # }
}

