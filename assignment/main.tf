terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.71.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

// tfstate file 
# terraform {
#   backend "azurerm" {
#     resource_group_name  = "storage-rg"
#     storage_account_name = "terraformstaccnt"
#     container_name       = "remotestatecontainer"
#     key                  = "state.tfstate"
#   }
# }
