# Virtual Network Links of Private DNS Zones (Shared)
resource "azurerm_private_dns_zone_virtual_network_link" "key_vault_dns_vnetlink" {
  provider              = azurerm.azure_shared
  name                  = "${azurerm_virtual_network.network_vnet.name}-nl"
  resource_group_name   = data.azurerm_private_dns_zone.key_vault_dns.resource_group_name
  private_dns_zone_name = data.azurerm_private_dns_zone.key_vault_dns.name
  virtual_network_id    = azurerm_virtual_network.network_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "storage_blob_dns_vnetlink" {
  provider              = azurerm.azure_shared
  name                  = "${azurerm_virtual_network.network_vnet.name}-nl"
  resource_group_name   = data.azurerm_private_dns_zone.storage_blob_dns.resource_group_name
  private_dns_zone_name = data.azurerm_private_dns_zone.storage_blob_dns.name
  virtual_network_id    = azurerm_virtual_network.network_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "storage_file_dns_vnetlink" {
  provider              = azurerm.azure_shared
  name                  = "${azurerm_virtual_network.network_vnet.name}-nl"
  resource_group_name   = data.azurerm_private_dns_zone.storage_file_dns.resource_group_name
  private_dns_zone_name = data.azurerm_private_dns_zone.storage_file_dns.name
  virtual_network_id    = azurerm_virtual_network.network_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "mssql_server_dns_vnetlink" {
  provider              = azurerm.azure_shared
  name                  = "${azurerm_virtual_network.network_vnet.name}-nl"
  resource_group_name   = data.azurerm_private_dns_zone.mssql_server_dns.resource_group_name
  private_dns_zone_name = data.azurerm_private_dns_zone.mssql_server_dns.name
  virtual_network_id    = azurerm_virtual_network.network_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgresql_server_dns_vnetlink" {
  provider              = azurerm.azure_shared
  name                  = "${azurerm_virtual_network.network_vnet.name}-nl"
  resource_group_name   = data.azurerm_private_dns_zone.postgresql_server_dns.resource_group_name
  private_dns_zone_name = data.azurerm_private_dns_zone.postgresql_server_dns.name
  virtual_network_id    = azurerm_virtual_network.network_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "eventhub_ns_dns_vnetlink" {
  provider              = azurerm.azure_shared
  name                  = "${azurerm_virtual_network.network_vnet.name}-nl"
  resource_group_name   = data.azurerm_private_dns_zone.eventhub_ns_dns.resource_group_name
  private_dns_zone_name = data.azurerm_private_dns_zone.eventhub_ns_dns.name
  virtual_network_id    = azurerm_virtual_network.network_vnet.id
}