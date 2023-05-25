# Eventhub Namespace
resource "azurerm_eventhub_namespace" "eventhub_ns" {
  name                = "${var.eventhub_ns["name"]}-${var.environment["name"]}-${var.environment["location_shortcut"]}-evhns01"
  resource_group_name = azurerm_resource_group.product_rg.name
  location            = azurerm_resource_group.product_rg.location
  sku                 = var.eventhub_ns["sku"]
  capacity            = var.eventhub_ns["sku_capacity"]
  tags                = var.default_tags

  network_rulesets {
    default_action                  = var.eventhub_ns["default_action"]
    trusted_service_access_enabled  = var.eventhub_ns["trusted_service_access_enabled"]
    
    ip_rule = [
      {
        ip_mask = var.eventhub_ns["ip_mask"]
        action  = "Allow"
      }
    ]    
  }
}

resource "azurerm_key_vault_secret" "eventhub_ns_accesskey" {
  name         = "${var.eventhub_ns["name"]}-evhns01-accesskey"
  value        = azurerm_eventhub_namespace.eventhub_ns.default_primary_key
  key_vault_id = azurerm_key_vault.key_vault.id
  content_type = "text/plain"
  tags         = var.default_tags
}

resource "azurerm_key_vault_secret" "eventhub_ns_connectionstring" {
  name         = "${var.eventhub_ns["name"]}-evhns01-connectionstring"
  value        = azurerm_eventhub_namespace.eventhub_ns.default_primary_connection_string
  key_vault_id = azurerm_key_vault.key_vault.id
  content_type = "text/plain"
  tags         = var.default_tags
}

resource "azurerm_private_endpoint" "eventhub_ns_pe" {
  name                = "${azurerm_eventhub_namespace.eventhub_ns.name}-pe"
  resource_group_name = azurerm_resource_group.product_rg.name
  location            = azurerm_resource_group.product_rg.location
  subnet_id           = data.azurerm_subnet.private_endpoint_subnet.id
  tags                = var.default_tags

  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.eventhub_ns_dns.id]
  }

  private_service_connection {
    name                           = "${azurerm_eventhub_namespace.eventhub_ns.name}-psc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_eventhub_namespace.eventhub_ns.id
    subresource_names              = ["namespace"]
  }
}

# Eventhub Hubs
resource "azurerm_eventhub" "eventhub_hubs" {
  for_each            = var.eventhub_hubs
  name                = each.key
  namespace_name      = azurerm_eventhub_namespace.eventhub_ns.name
  resource_group_name = azurerm_resource_group.product_rg.name
  partition_count     = each.value["partition_count"]
  message_retention   = each.value["message_retention"]
}

# Eventhub Consumer groups
resource "azurerm_eventhub_consumer_group" "eventhub_consgrp" {
  for_each            = var.eventhub_hubs
  name                = each.value["consumer_group_name"]
  namespace_name      = azurerm_eventhub_namespace.eventhub_ns.name
  eventhub_name       = azurerm_eventhub.eventhub_hubs[each.key].name
  resource_group_name = azurerm_resource_group.product_rg.name
}

resource "azurerm_eventhub_authorization_rule" "eventhubauthrule_listen" {
  for_each            = var.eventhub_hubs
  name                = "${azurerm_eventhub.eventhub_hubs[each.key].name}-listen"
  namespace_name      = azurerm_eventhub_namespace.eventhub_ns.name
  eventhub_name       = azurerm_eventhub.eventhub_hubs[each.key].name
  resource_group_name = azurerm_resource_group.product_rg.name
  listen              = true
  send                = false
  manage              = false
}

resource "azurerm_key_vault_secret" "eventhubauthrule_listen_accesskey" {
  for_each     = var.eventhub_hubs
  name         = "${var.eventhub_ns["name"]}-evhns01-${azurerm_eventhub_authorization_rule.eventhubauthrule_listen[each.key].name}-accesskey"
  value        = azurerm_eventhub_authorization_rule.eventhubauthrule_listen[each.key].primary_key
  key_vault_id = azurerm_key_vault.key_vault.id
  content_type = "text/plain"
  tags         = var.default_tags
}

resource "azurerm_key_vault_secret" "eventhubauthrule_listen_connectionstring" {
  for_each     = var.eventhub_hubs
  name         = "${var.eventhub_ns["name"]}-evhns01-${azurerm_eventhub_authorization_rule.eventhubauthrule_listen[each.key].name}-connectionstring"
  value        = azurerm_eventhub_authorization_rule.eventhubauthrule_listen[each.key].primary_connection_string
  key_vault_id = azurerm_key_vault.key_vault.id
  content_type = "text/plain"
  tags         = var.default_tags
}

resource "azurerm_eventhub_authorization_rule" "eventhubauthrule_send" {
  for_each            = var.eventhub_hubs
  name                = "${azurerm_eventhub.eventhub_hubs[each.key].name}-send"
  namespace_name      = azurerm_eventhub_namespace.eventhub_ns.name
  eventhub_name       = azurerm_eventhub.eventhub_hubs[each.key].name
  resource_group_name = azurerm_resource_group.product_rg.name
  listen              = false
  send                = true
  manage              = false
}

resource "azurerm_key_vault_secret" "eventhubauthrule_send_accesskey" {
  for_each     = var.eventhub_hubs
  name         = "${var.eventhub_ns["name"]}-evhns01-${azurerm_eventhub_authorization_rule.eventhubauthrule_send[each.key].name}-accesskey"
  value        = azurerm_eventhub_authorization_rule.eventhubauthrule_send[each.key].primary_key
  key_vault_id = azurerm_key_vault.key_vault.id
  content_type = "text/plain"
  tags         = var.default_tags
}

resource "azurerm_key_vault_secret" "eventhubauthrule_send_connectionstring" {
  for_each     = var.eventhub_hubs
  name         = "${var.eventhub_ns["name"]}-evhns01-${azurerm_eventhub_authorization_rule.eventhubauthrule_send[each.key].name}-connectionstring"
  value        = azurerm_eventhub_authorization_rule.eventhubauthrule_send[each.key].primary_connection_string
  key_vault_id = azurerm_key_vault.key_vault.id
  content_type = "text/plain"
  tags         = var.default_tags
}