# Azure SQL Database
resource "azurerm_mssql_server" "mssql_server" {
  name                          = "${var.mssql_server["name"]}-mssql-${var.environment["name"]}-${var.environment["location_shortcut"]}-srv01"
  location                      = azurerm_resource_group.product_rg.location
  resource_group_name           = azurerm_resource_group.product_rg.name
  version                       = var.mssql_server.version
  administrator_login           = var.mssql_server.administrator_login
  administrator_login_password  = random_password.mssql_adminpw.result
  public_network_access_enabled = var.mssql_server.public_network_access_enabled
  minimum_tls_version           = "1.2"
  tags                          = var.default_tags

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_sql_firewall_rule" "mssql_firewall_rule1" {
  count               = var.mssql_server["public_network_access_enabled"] ? 1 : 0
  name                = "AllowAccessToAzureServices"
  resource_group_name = azurerm_mssql_server.mssql_server.resource_group_name
  server_name         = azurerm_mssql_server.mssql_server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_mssql_database" "mssql_database" {
  name             = "${var.mssql_database["name"]}-mssql-${var.environment["name"]}-${var.environment["location_shortcut"]}-db01"
  server_id        = azurerm_mssql_server.mssql_server.id
  sku_name         = var.mssql_database.sku_name
  max_size_gb      = var.mssql_database.max_size_gb
  collation        = var.mssql_database.collation
  tags             = var.default_tags
}

resource "random_password" "mssql_adminpw" {
  length           = 32
  special          = true
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
  override_special = "@#&*()?"
}

resource "azurerm_key_vault_secret" "mssql_adminuser" {
  name         = "${var.mssql_server["name"]}-mssql-srv01-user"
  value        = azurerm_mssql_server.mssql_server.administrator_login
  key_vault_id = azurerm_key_vault.key_vault.id
  content_type = "text/plain"
  tags         = var.default_tags
}

resource "azurerm_key_vault_secret" "mssql_adminpw" {
  name         = "${var.mssql_server["name"]}-mssql-srv01-pw"
  value        = azurerm_mssql_server.mssql_server.administrator_login_password
  key_vault_id = azurerm_key_vault.key_vault.id
  content_type = "text/plain"
  tags         = var.default_tags
}

resource "azurerm_private_endpoint" "mssql_server_pe" {
  name                = "${azurerm_mssql_server.mssql_server.name}-pe"
  resource_group_name = azurerm_resource_group.product_rg.name
  location            = azurerm_resource_group.product_rg.location
  subnet_id           = data.azurerm_subnet.private_endpoint_subnet.id
  tags                = var.default_tags

  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.mssql_server_dns.id]
  }

  private_service_connection {
    name                           = "${azurerm_mssql_server.mssql_server.name}-psc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_mssql_server.mssql_server.id
    subresource_names              = ["sqlServer"]
  }
}

resource "azurerm_key_vault_access_policy" "mssql_key_vault_ap" {
  key_vault_id       = azurerm_key_vault.key_vault.id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = azurerm_mssql_server.mssql_server.identity.0.principal_id
  key_permissions    = ["Get", "Wrapkey", "Unwrapkey"]
  secret_permissions = ["Get"]
}

resource "azurerm_key_vault_key" "mssql_customer_managed_key" {
  name         = "mssql-customer-managed-key"
  key_vault_id = azurerm_key_vault.key_vault.id
  key_type     = azurerm_key_vault.key_vault.sku_name == "premium" ? "RSA-HSM" : "RSA"
  key_size     = 2048
  key_opts     = ["encrypt", "decrypt", "wrapKey", "unwrapKey", "sign", "verify"]
  tags         = var.default_tags
  
  depends_on = [
    azurerm_key_vault_access_policy.key_vault_ap,
    azurerm_key_vault_access_policy.mssql_key_vault_ap
  ]
}

/*resource "azurerm_mssql_server_transparent_data_encryption" "mssql_customer_managed_key" {
   server_id        = azurerm_mssql_server.mssql_server.id
   key_vault_key_id = azurerm_key_vault_key.mssql_customer_managed_key.id
}*/