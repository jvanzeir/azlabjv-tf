locals {
  frontend_port_name             = "frontend-port"
  frontend_ip_configuration_name = "frontend-ip-config"
  http_listener_name             = "http-listener"
  backend_address_pool_name      = "backend-pool"
  backend_http_setting_name      = "backend-http-settings"
  request_routing_rule_name      = "routing-rule"
  gateway_ip_configuration       = "gateway-ip-config"
}

resource "azurerm_public_ip" "app_gateway_pip" {
  count               = var.app_gateway["app_gateway_deploy"] ? 1 : 0
  name                = "${var.app_gateway["name"] }-${var.environment["name"]}-${var.environment["location_shortcut"]}-agw-pip"
  resource_group_name = azurerm_resource_group.aks_rg[0].name
  location            = azurerm_resource_group.aks_rg[0].location
  sku                 = var.app_gateway["pip_sku"]
  allocation_method   = var.app_gateway["pip_allocation_method"]
  availability_zone   = "No-Zone"
  tags                = var.default_tags
}

resource "azurerm_application_gateway" "app_gateway" {
  count               = var.app_gateway["app_gateway_deploy"] ? 1 : 0
  name                = "${var.app_gateway["name"] }-${var.environment["name"]}-${var.environment["location_shortcut"]}-agw"
  resource_group_name = azurerm_resource_group.aks_rg[0].name
  location            = azurerm_resource_group.aks_rg[0].location
  tags                = var.default_tags

  sku {
    name = var.app_gateway["sku_name"]
    tier = var.app_gateway["sku_tier"]
  }

  autoscale_configuration {
    min_capacity = var.app_gateway["autoscale_min_capacity"]
    max_capacity = var.app_gateway["autoscale_max_capacity"]
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.app_gateway_pip[0].id
  }

  http_listener {
    name                           = local.http_listener_name 
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }
  
  backend_http_settings {
    name                  = local.backend_http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
  }

  gateway_ip_configuration {
    name      = local.gateway_ip_configuration
    subnet_id = azurerm_subnet.network_subnet["AppGateway"].id
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.http_listener_name 
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.backend_http_setting_name
  }

  waf_configuration {
    enabled                  = var.app_gateway["waf_enabled"]
    firewall_mode            = var.app_gateway["waf_firewall_mode"]
    rule_set_type            = var.app_gateway["waf_rule_set_type"]
    rule_set_version         = var.app_gateway["waf_rule_set_version"]
    file_upload_limit_mb     = var.app_gateway["waf_file_upload_limit_mb"]
    request_body_check       = var.app_gateway["waf_request_body_check"]
    max_request_body_size_kb = var.app_gateway["waf_max_request_body_size_kb"]
  }

  lifecycle {
    ignore_changes = [
      request_routing_rule,
      backend_http_settings,
      backend_address_pool,
      http_listener,
      frontend_port,
      probe,
      ssl_certificate,
      url_path_map,
      redirect_configuration,
      tags
    ]
  }
}

resource "azurerm_role_assignment" "reader_role_assignment_aks_rg" {
  count                            = var.app_gateway["app_gateway_deploy"] ? 1 : 0
  scope                            = azurerm_resource_group.aks_rg[0].id
  role_definition_name             = "Reader"
  principal_id                     = azurerm_kubernetes_cluster.aks_cluster[0].kubelet_identity[0].object_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "contributor_role_assignment_app_gateway" {
  count                            = var.app_gateway["app_gateway_deploy"] ? 1 : 0
  scope                            = azurerm_application_gateway.app_gateway[0].id
  role_definition_name             = "Contributor"
  principal_id                     = azurerm_kubernetes_cluster.aks_cluster[0].kubelet_identity[0].object_id
  skip_service_principal_aad_check = true
}

resource "azurerm_monitor_diagnostic_setting" "app_gateway_diagnostic_settings" {
  count                      = var.app_gateway["app_gateway_deploy"] ? 1 : 0
  name                       = "${azurerm_application_gateway.app_gateway[0].name}-diag"
  target_resource_id         = azurerm_application_gateway.app_gateway[0].id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  log {
    category = "ApplicationGatewayAccessLog"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "ApplicationGatewayFirewallLog"
    enabled  = true

    retention_policy {
      days    = var.app_gateway["diagnostics_retention"]
      enabled = true
    }
  }

  log {
    category = "ApplicationGatewayPerformanceLog"
    enabled  = false

    retention_policy {
      enabled = false
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
