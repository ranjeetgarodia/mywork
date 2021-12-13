terraform {
  backend "azurerm" {
    resource_group_name  = "storage-rg"
    storage_account_name = "terraformstaccnt"
    container_name       = "remotestatecontainer"
    key                  = "demo7-modules-prod.tfstate"
  }
}

module "prodmodule" {
    source = "../../main"
    rgname = "prod-rg1"
    
}

