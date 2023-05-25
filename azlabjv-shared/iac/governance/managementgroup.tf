# Management Group
resource "azurerm_management_group" "management_group" {
  name         = var.management_group.name
  display_name = var.management_group.display_name

  subscription_ids = [
    data.azurerm_client_config.current.subscription_id
  ]
}