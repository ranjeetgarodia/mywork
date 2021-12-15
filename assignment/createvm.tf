# https://docs.microsoft.com/en-us/azure/developer/terraform/create-linux-virtual-machine-with-infrastructure

//create vnet:
resource "azurerm_virtual_network" "example" {
  name                = "${var.name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

//create subnet
resource "azurerm_subnet" "example" {
  name                 = "${var.name}-subnet-1"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "example" {
  name                = "myNetworkSecurityGroup"
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name

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

  tags = {
    environment = "Terraform Demo"
  }
}

# Create public IPs
resource "azurerm_public_ip" "example" {
  name                = "${var.name}-vm01-publicip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Dynamic"

  tags = {
    environment = "Terraform Demo"
  }
}

//create nic:
resource "azurerm_network_interface" "example" {
  name                = "${var.name}-vm01-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }

}


# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.example.id
  network_security_group_id = azurerm_network_security_group.example.id
}

# Create (and display) an SSH key
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
output "tls_private_key" {
  value     = tls_private_key.example_ssh.private_key_pem
  sensitive = true
}

output "tls_public_key" {
  value = tls_private_key.example_ssh.public_key_openssh
}

# resource "azurerm_key_vault_secret" "vmusername" {
#   name  = "azureuser"
#   value = "azureuser"
#   key_vault_id = azurerm_key_vault.example.id
# }

# data "azurerm_key_vault_secret" "vmusername" {
#   name         = azurerm_key_vault_secret.vmusername.name
#   key_vault_id = data.azurerm_key_vault.keyvault.id
# }

resource "azurerm_key_vault_secret" "vmsecretssh" {
  name         = "${var.name}-vm01-ssh"
  value        = tls_private_key.example_ssh.public_key_openssh
  key_vault_id = azurerm_key_vault.example.id
}

data "azurerm_key_vault_secret" "vmsecretssh" {
  name         = azurerm_key_vault_secret.vmsecretssh.name
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "example" {
  name                  = "${var.name}-vm01"
  location              = var.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.example.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name  = "myvm"
  admin_username = "azureuser"
  #   admin_username                  = data.azurerm_key_vault_secret.username.value
  disable_password_authentication = true

  admin_ssh_key {
    username = "azureuser"
    # public_key = tls_private_key.example_ssh.public_key_openssh
    public_key = data.azurerm_key_vault_secret.vmsecretssh.value
  }

}