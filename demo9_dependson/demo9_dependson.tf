provider "azurerm" {
  version = "~>2.18"

  features {}

  subscription_id = "6c903494-a6a9-4bb5-80ad-a6b1816c67b3"
  client_id       = "a62210da-21dd-4d81-8c10-d6fe69cba69b"
  client_secret   = "HWu7Q~LI1qAbuaIUtj6SDE62skBbIzM4RdhCx"
  tenant_id       = "a66d2e30-7919-43a0-8b5d-a355f1e2e08d"
}

resource "azurerm_resource_group" "rg1" {
  name     = "rg1"
  location = "eastus"
  depends_on =[azurerm_resource_group.rg3]
}

resource "azurerm_resource_group" "rg2" {
  name     = "rg2"
  location = "eastus"
    depends_on = [
    azurerm_resource_group.rg1
  ]
}

resource "azurerm_resource_group" "rg3" {
  name     = "rg3"
  location = "eastus"
}


