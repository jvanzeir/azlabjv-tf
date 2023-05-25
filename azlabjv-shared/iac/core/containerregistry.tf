# Resource Group Azure Container Registry
resource "azurerm_resource_group" "container_registry_rg" {
  count    = var.container_registry["container_registry_deploy"] ? 1 : 0
  name     = "acr-${var.environment["name"]}-${var.environment["location_shortcut"]}-rg"
  location = var.environment["location"]
  tags     = var.default_tags
}

# Azure Container Registry
resource "azurerm_container_registry" "container_registry" {
  count                    = var.container_registry["container_registry_deploy"] ? 1 : 0
  name                     = "${var.container_registry["name"]}${var.environment["name"]}${var.environment["location_shortcut"]}acr"
  resource_group_name      = azurerm_resource_group.container_registry_rg[0].name
  location                 = azurerm_resource_group.container_registry_rg[0].location
  sku                      = var.container_registry["sku"]
  admin_enabled            = false
  trust_policy             = [{
    enabled                = var.container_registry["content_trust"]
  }]
  dynamic "georeplications" {
    for_each = var.container_registry["sku"] == "Premium" ?  [var.container_registry["georeplication_location"]] : [] 
    content {
      location = georeplications.value
    }
  }
  tags                     = var.default_tags
}