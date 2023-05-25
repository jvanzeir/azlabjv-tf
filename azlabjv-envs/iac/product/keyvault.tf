# Keyvault
resource "azurerm_key_vault" "key_vault" {
  name                            = "${var.key_vault.name}-${var.environment["name"]}-${var.environment["location_shortcut"]}-kv"
  location                        = azurerm_resource_group.product_rg.location
  resource_group_name             = azurerm_resource_group.product_rg.name
  enabled_for_disk_encryption     = false
  enabled_for_template_deployment = false
  purge_protection_enabled        = true
  soft_delete_retention_days      = 90
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  sku_name                        = var.key_vault.sku
  tags                            = var.default_tags

  network_acls {
    default_action                = var.key_vault["default_action"]
    bypass                        = var.key_vault["bypass"]
    ip_rules                      = var.key_vault["ip_rules"] != "" ? split(",", var.key_vault["ip_rules"]) : null
  }
}

resource "azurerm_key_vault_access_policy" "key_vault_ap" {
  key_vault_id            = azurerm_key_vault.key_vault.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = data.azurerm_client_config.current.object_id

  key_permissions         = ["Get", "List", "Create", "Update", "Delete", "Purge", "Recover", "Backup", "Restore"]
  secret_permissions      = ["Get", "List", "Set", "Delete", "Purge", "Recover", "Backup", "Restore"]
  certificate_permissions = ["Get", "List", "Create", "Update", "Delete", "Purge", "Recover", "Backup", "Restore"]
}

resource "azurerm_private_endpoint" "key_vault_pe" {
  name                = "${azurerm_key_vault.key_vault.name}-pe"
  resource_group_name = azurerm_resource_group.product_rg.name
  location            = azurerm_resource_group.product_rg.location
  subnet_id           = data.azurerm_subnet.private_endpoint_subnet.id
  tags                = var.default_tags

  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.key_vault_dns.id]
  }

  private_service_connection {
    name                           = "${azurerm_key_vault.key_vault.name}-psc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_key_vault.key_vault.id
    subresource_names              = ["vault"]
  }
}