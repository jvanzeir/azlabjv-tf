# Storage Account
resource "azurerm_storage_account" "storage_account" {
  for_each                  = var.storage_accounts
  name                      = "${each.value["name"]}${var.environment["name"]}${var.environment["location_shortcut"]}st${each.value["count"]}"
  resource_group_name       = azurerm_resource_group.product_rg.name
  location                  = azurerm_resource_group.product_rg.location
  account_kind              = "StorageV2"
  account_tier              = each.value["tier"]
  account_replication_type  = each.value["replication"]
  access_tier               = each.value["access"]
  enable_https_traffic_only = true
  min_tls_version           = each.value["min_tls_version"]
  tags                      = var.default_tags

  identity {
    type = "SystemAssigned"
  }

  network_rules {
    default_action          = each.value["default_action"]
    bypass                  = split(",", each.value["bypass"])
    ip_rules                = each.value["ip_rules"] != "" ?  split(",", each.value["ip_rules"]) : null
  }
}

resource "azurerm_storage_container" "storage_container" {
  for_each              = var.storage_containers
  name                  = each.value["name"]
  container_access_type = each.value["container_access_type"]
  storage_account_name  = azurerm_storage_account.storage_account[each.value["storage_account_name"]].name
}

resource "azurerm_storage_share" "storage_share" {
  for_each              = var.storage_fileshares
  name                  = each.value["name"]
  quota                 = each.value["quota"]
  storage_account_name  = azurerm_storage_account.storage_account[each.value["storage_account_name"]].name
}

resource "azurerm_key_vault_secret" "storage_accesskey" {
  for_each     = var.storage_accounts
  name         = "${each.key}-accesskey"
  value        = azurerm_storage_account.storage_account[each.key].primary_access_key
  key_vault_id = azurerm_key_vault.key_vault.id
  content_type = "text/plain"
  tags         = var.default_tags
}

resource "azurerm_key_vault_secret" "storage_connectionstring" {
  for_each     = var.storage_accounts
  name         = "${each.key}-connectionstring"
  value        = azurerm_storage_account.storage_account[each.key].primary_connection_string
  key_vault_id = azurerm_key_vault.key_vault.id
  content_type = "text/plain"
  tags         = var.default_tags
}

resource "azurerm_private_endpoint" "storage_blob_pe" {
  for_each            = var.storage_accounts
  name                = "${azurerm_storage_account.storage_account[each.key].name}-blob-pe"
  resource_group_name = azurerm_resource_group.product_rg.name
  location            = azurerm_resource_group.product_rg.location
  subnet_id           = data.azurerm_subnet.private_endpoint_subnet.id
  tags                = var.default_tags

  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.storage_blob_dns.id]
  }

  private_service_connection {
    name                           = "${azurerm_storage_account.storage_account[each.key].name}-blob-psc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.storage_account[each.key].id
    subresource_names              = ["blob"]
  }
}

resource "azurerm_private_endpoint" "storage_file_pe" {
  for_each            = var.storage_accounts
  name                = "${azurerm_storage_account.storage_account[each.key].name}-file-pe"
  resource_group_name = azurerm_resource_group.product_rg.name
  location            = azurerm_resource_group.product_rg.location
  subnet_id           = data.azurerm_subnet.private_endpoint_subnet.id
  tags                = var.default_tags

  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.storage_file_dns.id]
  }

  private_service_connection {
    name                           = "${azurerm_storage_account.storage_account[each.key].name}-file-psc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.storage_account[each.key].id
    subresource_names              = ["file"]
  }
}

resource "azurerm_key_vault_access_policy" "storage_key_vault_ap" {
  for_each           = var.storage_accounts
  key_vault_id       = azurerm_key_vault.key_vault.id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = azurerm_storage_account.storage_account[each.key].identity.0.principal_id
  key_permissions    = ["Get", "Wrapkey", "Unwrapkey"]
  secret_permissions = ["Get"]
}

resource "azurerm_key_vault_key" "storage_customer_managed_key" {
  name         = "storage-customer-managed-key"
  key_vault_id = azurerm_key_vault.key_vault.id
  key_type     = azurerm_key_vault.key_vault.sku_name == "premium" ? "RSA-HSM" : "RSA"
  key_size     = 2048
  key_opts     = ["encrypt", "decrypt", "wrapKey", "unwrapKey", "sign", "verify"]
  tags         = var.default_tags
  
  depends_on = [
    azurerm_key_vault_access_policy.key_vault_ap,
    azurerm_key_vault_access_policy.storage_key_vault_ap
  ]
}
resource "azurerm_storage_account_customer_managed_key" "storage_customer_managed_key" {
  for_each           = var.storage_accounts
  storage_account_id = azurerm_storage_account.storage_account[each.key].id
  key_vault_id       = azurerm_key_vault.key_vault.id
  key_name           = azurerm_key_vault_key.storage_customer_managed_key.name
}