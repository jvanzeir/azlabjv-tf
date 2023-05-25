# Resource Group Networking
resource "azurerm_resource_group" "network_rg" {
  name     = "network-${var.environment["name"]}-${var.environment["location_shortcut"]}-rg"
  location = var.environment["location"]
  tags     = var.default_tags
}

# Resource Group Management
resource "azurerm_resource_group" "mgmt_rg" {
  name     = "mgmt-${var.environment["name"]}-${var.environment["location_shortcut"]}-rg"
  location = var.environment["location"]
  tags     = var.default_tags
}