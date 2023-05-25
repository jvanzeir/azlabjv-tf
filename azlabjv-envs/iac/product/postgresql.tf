# PostgreSQL
resource "azurerm_postgresql_server" "postgresql_server" {
  name                             = "${var.postgresql_server["name"]}-psql-${var.environment["name"]}-${var.environment["location_shortcut"]}-srv01"
  location                         = azurerm_resource_group.product_rg.location
  resource_group_name              = azurerm_resource_group.product_rg.name
  sku_name                         = var.postgresql_server.sku_name
  version                          = var.postgresql_server.version
  storage_mb                       = var.postgresql_server.storage_mb
  backup_retention_days            = var.postgresql_server.backup_retention_days
  geo_redundant_backup_enabled     = var.postgresql_server.geo_redundant_backup_enabled
  auto_grow_enabled                = var.postgresql_server.auto_grow_enabled
  administrator_login              = var.postgresql_server.administrator_login
  administrator_login_password     = random_password.postgresql_adminpw.result
  public_network_access_enabled    = var.postgresql_server.public_network_access_enabled
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
  tags                             = var.default_tags

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_postgresql_firewall_rule" "postgresql_firewall_rule1" {
  count               = var.postgresql_server["public_network_access_enabled"] ? 1 : 0
  name                = "AllowAccessToAzureServices"
  resource_group_name = azurerm_postgresql_server.postgresql_server.resource_group_name
  server_name         = azurerm_postgresql_server.postgresql_server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_postgresql_database" "postgresql_dbs" {
  for_each            = toset(split(";", var.postgresql_server["databases"]))
  name                = each.key
  resource_group_name = azurerm_postgresql_server.postgresql_server.resource_group_name
  server_name         = azurerm_postgresql_server.postgresql_server.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

resource "random_password" "postgresql_adminpw" {
  length           = 32
  special          = true
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
  override_special = "@#&*()?"
}

resource "azurerm_key_vault_secret" "postgresql_adminuser" {
  name         = "${var.postgresql_server["name"]}-psql-srv01-user"
  value        = azurerm_postgresql_server.postgresql_server.administrator_login
  key_vault_id = azurerm_key_vault.key_vault.id
  content_type = "text/plain"
  tags         = var.default_tags
}

resource "azurerm_key_vault_secret" "postgresql_adminpw" {
  name         = "${var.postgresql_server["name"]}-psql-srv01-pw"
  value        = azurerm_postgresql_server.postgresql_server.administrator_login_password
  key_vault_id = azurerm_key_vault.key_vault.id
  content_type = "text/plain"
  tags         = var.default_tags
}

resource "azurerm_private_endpoint" "postgresql_server_pe" {
  name                = "${azurerm_postgresql_server.postgresql_server.name}-pe"
  resource_group_name = azurerm_resource_group.product_rg.name
  location            = azurerm_resource_group.product_rg.location
  subnet_id           = data.azurerm_subnet.private_endpoint_subnet.id
  tags                = var.default_tags

  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.postgresql_server_dns.id]
  }

  private_service_connection {
    name                           = "${azurerm_postgresql_server.postgresql_server.name}-psc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_postgresql_server.postgresql_server.id
    subresource_names              = ["postgresqlServer"]
  }
}

resource "azurerm_key_vault_access_policy" "postgresql_key_vault_ap" {
  key_vault_id       = azurerm_key_vault.key_vault.id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = azurerm_postgresql_server.postgresql_server.identity.0.principal_id
  key_permissions    = ["Get", "Wrapkey", "Unwrapkey"]
  secret_permissions = ["Get"]
}

resource "azurerm_key_vault_key" "postgresql_customer_managed_key" {
  name         = "postgresql-customer-managed-key"
  key_vault_id = azurerm_key_vault.key_vault.id
  key_type     = azurerm_key_vault.key_vault.sku_name == "premium" ? "RSA-HSM" : "RSA"
  key_size     = 2048
  key_opts     = ["encrypt", "decrypt", "wrapKey", "unwrapKey", "sign", "verify"]
  tags         = var.default_tags
  
  depends_on = [
    azurerm_key_vault_access_policy.key_vault_ap,
    azurerm_key_vault_access_policy.postgresql_key_vault_ap
  ]
}

resource "azurerm_postgresql_server_key" "postgresql_customer_managed_key" {
  server_id        = azurerm_postgresql_server.postgresql_server.id
  key_vault_key_id = azurerm_key_vault_key.postgresql_customer_managed_key.id
}