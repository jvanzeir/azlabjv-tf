# Resource Group DNS
resource "azurerm_resource_group" "dns_rg" {
  name     = "dns-${var.environment["name"]}-${var.environment["location_shortcut"]}-rg"
  location = var.environment["location"]
  tags     = var.default_tags
}

# Private DNS Zones
resource "azurerm_private_dns_zone" "key_vault_dns" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.dns_rg.name
  tags                = var.default_tags
}

resource "azurerm_private_dns_zone" "storage_blob_dns" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.dns_rg.name
  tags                = var.default_tags
}

resource "azurerm_private_dns_zone" "storage_file_dns" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = azurerm_resource_group.dns_rg.name
  tags                = var.default_tags
}

resource "azurerm_private_dns_zone" "mssql_server_dns" {
  name                = "privatelink.database.windows.net"
  resource_group_name = azurerm_resource_group.dns_rg.name
  tags                = var.default_tags
}

resource "azurerm_private_dns_zone" "postgres_sqlserver_dns" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.dns_rg.name
  tags                = var.default_tags
}

resource "azurerm_private_dns_zone" "eventhub_ns_dns" {
  name                = "privatelink.servicebus.windows.net"
  resource_group_name = azurerm_resource_group.dns_rg.name
  tags                = var.default_tags
}

# Virtual Network Links of Private DNS Zones
resource "azurerm_private_dns_zone_virtual_network_link" "key_vault_dns_vnetlink" {
  name                  = "${azurerm_virtual_network.network_vnet.name}-nl"
  resource_group_name   = azurerm_private_dns_zone.key_vault_dns.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.key_vault_dns.name
  virtual_network_id    = azurerm_virtual_network.network_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "storage_blob_dns_vnetlink" {
  name                  = "${azurerm_virtual_network.network_vnet.name}-nl"
  resource_group_name   = azurerm_private_dns_zone.storage_blob_dns.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.storage_blob_dns.name
  virtual_network_id    = azurerm_virtual_network.network_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "storage_file_dns_vnetlink" {
  name                  = "${azurerm_virtual_network.network_vnet.name}-nl"
  resource_group_name   = azurerm_private_dns_zone.storage_file_dns.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.storage_file_dns.name
  virtual_network_id    = azurerm_virtual_network.network_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "mssql_server_dns_vnetlink" {
  name                  = "${azurerm_virtual_network.network_vnet.name}-nl"
  resource_group_name   = azurerm_private_dns_zone.mssql_server_dns.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.mssql_server_dns.name
  virtual_network_id    = azurerm_virtual_network.network_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgres_sqlserver_dns_vnetlink" {
  name                  = "${azurerm_virtual_network.network_vnet.name}-nl"
  resource_group_name   = azurerm_private_dns_zone.postgres_sqlserver_dns.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.postgres_sqlserver_dns.name
  virtual_network_id    = azurerm_virtual_network.network_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "eventhub_ns_dns_vnetlink" {
  name                  = "${azurerm_virtual_network.network_vnet.name}-nl"
  resource_group_name   = azurerm_private_dns_zone.eventhub_ns_dns.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.eventhub_ns_dns.name
  virtual_network_id    = azurerm_virtual_network.network_vnet.id
}