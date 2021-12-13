provider "azurerm" {
    features {}

subscription_id = "6c903494-a6a9-4bb5-80ad-a6b1816c67b3"
client_id     = "a62210da-21dd-4d81-8c10-d6fe69cba69b"
client_secret = "HWu7Q~LI1qAbuaIUtj6SDE62skBbIzM4RdhCx"
tenant_id     = "a66d2e30-7919-43a0-8b5d-a355f1e2e08d"

}
terraform {
  backend "azurerm" {
    resource_group_name  = "storage-rg"
    storage_account_name = "terraformstaccnt"
    container_name       = "remotestatecontainer"
    key                  = "demo2.tfstate"
  }
}

resource "azurerm_resource_group" "demo21" {
  name     = "demo2rg1"
  location = "westus"
  
}

