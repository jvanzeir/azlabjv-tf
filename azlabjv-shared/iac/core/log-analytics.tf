# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = "${var.environment["company"]}-${var.environment["name"]}-${var.environment["location_shortcut"]}-log"
  resource_group_name = azurerm_resource_group.mgmt_rg.name
  location            = azurerm_resource_group.mgmt_rg.location
  sku                 = var.log_analytics_workspace.sku
  retention_in_days   = var.log_analytics_workspace.retention_in_days
  tags                = var.default_tags
}