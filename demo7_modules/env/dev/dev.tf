
terraform {
  backend "azurerm" {
    resource_group_name  = "storage-rg"
    storage_account_name = "terraformstaccnt"
    container_name       = "remotestatecontainer"
    key                  = "demo7-modules-dev.tfstate"
  }
}

module "devmodule" {
    source = "../../main"
    rgname = "dev-rg1"
    
}

