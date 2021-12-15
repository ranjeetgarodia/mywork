
#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "example" {
  name                       = "${var.name}-kv"
  location                   = azurerm_resource_group.example.location
  resource_group_name        = azurerm_resource_group.example.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7

  tags = {
    environment = "Terraform Demo"

  }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "create",
      "get",
    ]

    secret_permissions = [
      "set",
      "get",
      "delete",
      "purge",
      "recover"
    ]
  }
}

data "azurerm_key_vault" "keyvault" {
  name                = azurerm_key_vault.example.name
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_key_vault_secret" "example" {
  name  = "test-secret"
  value = "test-secret-value"

  key_vault_id = azurerm_key_vault.example.id
}

resource "azurerm_key_vault_secret" "username" {
  name  = "azureuser"
  value = "azureuser"
  #   value        = data.secret.value

  key_vault_id = azurerm_key_vault.example.id
}

data "azurerm_key_vault_secret" "username" {
  name         = azurerm_key_vault_secret.username.name
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

output "kv_id" {
  value = azurerm_key_vault.example.id
}

