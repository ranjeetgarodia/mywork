
terraform {
  backend "azurerm" {
    resource_group_name  = "storage-rg"
    storage_account_name = "terraformstaccnt"
    container_name       = "remotestatecontainer"
    key                  = "sec06_lab6.4.tfstate"
  }
}
