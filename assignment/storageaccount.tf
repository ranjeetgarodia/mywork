
# Create storage account for tfsate file
resource "azurerm_storage_account" "example" {
  name                     = "staccnt${var.storage_accountname}"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "Terraform Demo"
  }
}

//create container
resource "azurerm_storage_container" "example" {
  name                 = "tf-statefile"
  storage_account_name = azurerm_storage_account.example.name
  #  container_access_type = "private"
  container_access_type = "private"
}
