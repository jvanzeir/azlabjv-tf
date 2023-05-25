data "azurerm_client_config" "current" {
}

data "azurerm_virtual_network" "network_shared" {
  provider            = azurerm.azure_shared
  name                = "${var.environment["company"]}-shared-${var.environment["location_shortcut"]}-vnet"
  resource_group_name = "network-shared-${var.environment["location_shortcut"]}-rg"
}

data "azurerm_firewall" "firewall_shared" {
  count               = var.firewall["firewall_deploy"] ? 1 : 0
  provider            = azurerm.azure_shared
  name                = "${var.environment["company"]}-shared-${var.environment["location_shortcut"]}-afw"
  resource_group_name = "network-shared-${var.environment["location_shortcut"]}-rg"
}

data "azurerm_private_dns_zone" "key_vault_dns" {
  provider            = azurerm.azure_shared
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = "dns-shared-${var.environment["location_shortcut"]}-rg"
}

data "azurerm_private_dns_zone" "storage_blob_dns" {
  provider            = azurerm.azure_shared
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = "dns-shared-${var.environment["location_shortcut"]}-rg"
}

data "azurerm_private_dns_zone" "storage_file_dns" {
  provider            = azurerm.azure_shared
  name                = "privatelink.file.core.windows.net"
  resource_group_name = "dns-shared-${var.environment["location_shortcut"]}-rg"
}

data "azurerm_private_dns_zone" "mssql_server_dns" {
  provider            = azurerm.azure_shared
  name                = "privatelink.database.windows.net"
  resource_group_name = "dns-shared-${var.environment["location_shortcut"]}-rg"
}

data "azurerm_private_dns_zone" "postgresql_server_dns" {
  provider            = azurerm.azure_shared
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = "dns-shared-${var.environment["location_shortcut"]}-rg"
}

data "azurerm_private_dns_zone" "eventhub_ns_dns" {
  provider            = azurerm.azure_shared
  name                = "privatelink.servicebus.windows.net"
  resource_group_name = "dns-shared-${var.environment["location_shortcut"]}-rg"
}