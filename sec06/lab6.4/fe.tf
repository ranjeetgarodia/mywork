#rg fe-rg
#pip pub-ip01
#fw  fw-01
#vnet fe-vnet

resource "azurerm_resource_group" "fe-rg" {
  name     = "${var.env}-fe-rg"
  location = var.location-name
}

/*
resource "azurerm_virtual_network" "fe-rg" {
  name                = "${var.env}-fe-vnet}"
  address_space       = ["10.0.0.0/23"]
  location            = azurerm_resource_group.fe-rg.location
  resource_group_name = azurerm_resource_group.fe-rg.name
}

resource "azurerm_subnet" "fe-rg-01" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.fe-rg.name
  virtual_network_name = azurerm_virtual_network.fe-rg.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "fe-rg-02" {
  name                 = "${var.env}-Jbox-subnet"
  resource_group_name  = azurerm_resource_group.fe-rg.name
  virtual_network_name = azurerm_virtual_network.fe-rg.name
  address_prefixes     = ["10.0.1.0/24"]
}
*/

#https://registry.terraform.io/modules/Azure/vnet/azurerm/2.1.0
module "fe-vnet" {
  source              = "Azure/vnet/azurerm"
  version             = "2.5.0"
  vnet_name           = "${var.env}-fe-vnet"
  resource_group_name = azurerm_resource_group.fe-rg.name
  # vnet_location       = azurerm_resource_group.fe-rg.location
  address_space       = ["10.0.0.0/23"]
  subnet_prefixes     = ["10.0.0.0/24", "10.0.1.0/24"]
  subnet_names        = ["AzureFirewallSubnet", "${var.env}-Jbox-subnet"]
  tags                = null
}

resource "azurerm_public_ip" "fe-rg" {
  name                = "${var.env}-pub-ip01"
  location            = azurerm_resource_group.fe-rg.location
  resource_group_name = azurerm_resource_group.fe-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "fe-rg" {
  name                = "${var.env}-FW-01"
  location            = azurerm_resource_group.fe-rg.location
  resource_group_name = azurerm_resource_group.fe-rg.name
  ip_configuration {
    name                 = "fwip-config"
    subnet_id            = module.fe-vnet.vnet_subnets[0]
    public_ip_address_id = azurerm_public_ip.fe-rg.id
  }
}