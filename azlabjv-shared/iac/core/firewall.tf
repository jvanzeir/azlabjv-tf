locals {
  firewall_name = "${var.environment["company"]}-${var.environment["name"]}-${var.environment["location_shortcut"]}-afw"
}

# Firewall Random URL
resource "random_string" "firewall_random_url" {
  count   = var.firewall["firewall_deploy"] ? 1 : 0
  length  = 8
  special = false
  upper   = false
}

# Firewall Puplic IP
resource "azurerm_public_ip" "firewall_pip" {
  count               = var.firewall["firewall_deploy"] ? 1 : 0
  name                = "${local.firewall_name}-pip01"
  resource_group_name = azurerm_resource_group.network_rg.name
  location            = azurerm_resource_group.network_rg.location
  sku                 = var.firewall["pip_sku"]
  allocation_method   = var.firewall["pip_allocation_method"]
  availability_zone   = "No-Zone"
  domain_name_label   = "${var.firewall["prefix"]}-${random_string.firewall_random_url[0].result}"
  tags                = var.default_tags
}

# Firewall
resource "azurerm_firewall" "firewall" {
  count               = var.firewall["firewall_deploy"] ? 1 : 0
  name                = local.firewall_name
  resource_group_name = azurerm_resource_group.network_rg.name
  location            = azurerm_resource_group.network_rg.location
  firewall_policy_id  = azurerm_firewall_policy.firewall_policy[0].id
  tags                = var.default_tags

  ip_configuration {
    name                 = "configuration01"
    subnet_id            = azurerm_subnet.network_subnet["AzureFirewall"].id
    public_ip_address_id = azurerm_public_ip.firewall_pip[0].id
  }
}

# Firewall Policy
resource "azurerm_firewall_policy" "firewall_policy" {
  count                    = var.firewall["firewall_deploy"] ? 1 : 0
  name                     = "${local.firewall_name}p"
  resource_group_name      = azurerm_resource_group.network_rg.name
  location                 = azurerm_resource_group.network_rg.location
  sku                      = var.firewall_policy["sku"]
  threat_intelligence_mode = var.firewall_policy["threat_intelligence_mode"]
  tags                     = var.default_tags

  dns {
    proxy_enabled          = var.firewall_policy["dns_proxy_enabled"]
    servers                = var.firewall_policy["dns_servers"] != "" ?  split(",", var.firewall_policy["dns_servers"]) : null
  }
}

# Firewall Policy NAT Rule Collection Group
resource "azurerm_firewall_policy_rule_collection_group" "nat_rule_collection_group" {
  count              = var.firewall["firewall_deploy"] ? 1 : 0
  name               = "nat-rcg"
  firewall_policy_id = azurerm_firewall_policy.firewall_policy[0].id
  priority           = 100

  nat_rule_collection {
    name                  = "nat-rc01"
    priority              = 110
    action                = "Dnat"
    dynamic "rule" {
      for_each = var.firewall_nat_rc01
      content {
        name                  = rule.value["name"]
        protocols             = split(",", rule.value["protocols"])
        source_addresses      = split(",", rule.value["source_addresses"])
        destination_address   = rule.value["destination_address"] != "" ?  rule.value["destination_address"] : azurerm_public_ip.firewall_pip[0].ip_address
        destination_ports     = split(",", rule.value["destination_ports"])
        translated_address    = rule.value["translated_address"]
        translated_port       = rule.value["translated_port"]
      }
    }
  }
}

# Firewall Policy Network Rule Collection Group
resource "azurerm_firewall_policy_rule_collection_group" "network_rule_collection_group" {
  count              = var.firewall["firewall_deploy"] ? 1 : 0
  name               = "network-rcg"
  firewall_policy_id = azurerm_firewall_policy.firewall_policy[0].id
  priority           = 200

  network_rule_collection {
    name     = "network-test-rc01"
    priority = 210
    action   = "Allow"
    dynamic "rule" {
      for_each = var.firewall_network_test_rc01
      content {
        name                  = rule.value["name"]
        protocols             = split(",", rule.value["protocols"])
        source_addresses      = split(",", rule.value["source_addresses"])
        destination_addresses = rule.value["destination_addresses"] == "" ? null : split(",", rule.value["destination_addresses"])
        destination_fqdns     = rule.value["destination_fqdns"] == "" ? null : split(",", rule.value["destination_fqdns"])
        destination_ports     = split(",", rule.value["destination_ports"])
      }
    }
  }

  network_rule_collection {
    name     = "network-int-rc01"
    priority = 220
    action   = "Allow"
    dynamic "rule" {
      for_each = var.firewall_network_int_rc01
      content {
        name                  = rule.value["name"]
        protocols             = split(",", rule.value["protocols"])
        source_addresses      = split(",", rule.value["source_addresses"])
        destination_addresses = rule.value["destination_addresses"] == "" ? null : split(",", rule.value["destination_addresses"])
        destination_fqdns     = rule.value["destination_fqdns"] == "" ? null : split(",", rule.value["destination_fqdns"])
        destination_ports     = split(",", rule.value["destination_ports"])
      }
    }
  }
  
  network_rule_collection {
    name     = "network-prod-rc01"
    priority = 230
    action   = "Allow"
    dynamic "rule" {
      for_each = var.firewall_network_prod_rc01
      content {
        name                  = rule.value["name"]
        protocols             = split(",", rule.value["protocols"])
        source_addresses      = split(",", rule.value["source_addresses"])
        destination_addresses = rule.value["destination_addresses"] == "" ? null : split(",", rule.value["destination_addresses"])
        destination_fqdns     = rule.value["destination_fqdns"] == "" ? null : split(",", rule.value["destination_fqdns"])
        destination_ports     = split(",", rule.value["destination_ports"])
      }
    }
  }
}

# Firewall Policy Application Rule Collection Group
resource "azurerm_firewall_policy_rule_collection_group" "application_rule_collection_group" {
  count              = var.firewall["firewall_deploy"] ? 1 : 0
  name               = "application-rcg"
  firewall_policy_id = azurerm_firewall_policy.firewall_policy[0].id
  priority           = 300

  application_rule_collection {
    name     = "application-rc01"
    priority = 310
    action   = "Allow"

    dynamic "rule" {
      for_each = var.firewall_application_rc01
      content {
        name                  = rule.value["name"]
        source_addresses      = split(",", rule.value["source_addresses"])
        destination_fqdns     = rule.value["destination_fqdns"] == "" ? null : split(",", rule.value["destination_fqdns"])
        destination_fqdn_tags = rule.value["destination_fqdn_tags"] == "" ? null : split(",", rule.value["destination_fqdn_tags"])
        protocols {
          type = rule.value["protocol_http"]
          port = rule.value["port_http"]
        }
        protocols {
          type = rule.value["protocol_https"]
          port = rule.value["port_https"]
        }
      }
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "firewall_diagnostic_setting" {
  count                      = var.firewall["firewall_deploy"] ? 1 : 0
  name                       = "${local.firewall_name}-diag"
  target_resource_id         = azurerm_firewall.firewall[0].id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  log {
    category = "AzureFirewallDnsProxy"
    enabled  = true

    retention_policy {
      days    = var.firewall["diagnostics_retention"]
      enabled = true
    }
  }

  log {
    category = "AzureFirewallNetworkRule"
    enabled  = true

    retention_policy {
      days    = var.firewall["diagnostics_retention"]
      enabled = true
    }
  }
  
  log {
    category = "AzureFirewallApplicationRule"
    enabled  = true

    retention_policy {
      days    = var.firewall["diagnostics_retention"]
      enabled = true
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }
}