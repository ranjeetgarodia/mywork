resource "azurerm_resource_group" "example" {
  name     = "${var.name}-rg"
  location = var.location
  tags = {
    environment = "Terraform Demo"
  }
}
