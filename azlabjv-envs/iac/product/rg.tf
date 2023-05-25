# Resource Group Project
resource "azurerm_resource_group" "product_rg" {
  name     = "product-${var.environment["name"]}-${var.environment["location_shortcut"]}-rg"
  location = var.environment["location"]
  tags = var.default_tags
}