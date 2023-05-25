# Security Center Auto Provisioning
resource "azurerm_security_center_auto_provisioning" "security_center_auto_provisioning" {
  count          = var.security_center["security_center_deploy"] ? 1 : 0
  auto_provision = "On"
}

# Security Center Workspace
resource "azurerm_security_center_workspace" "security_center_workspace" {
  count        = var.security_center["security_center_deploy"] ? 1 : 0
  scope        = "/subscriptions/${var.provider_subscription_id}"
  workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id
}

# Security Center Subscription Pricing (ARM)
resource "azurerm_security_center_subscription_pricing" "security_center_arm" {
  count         = var.security_center["security_center_deploy"] ? 1 : 0
  tier          = "Standard"
  resource_type = "Arm"
}

# Security Center Subscription Pricing (DNS)
resource "azurerm_security_center_subscription_pricing" "security_center_dns" {
  count         = var.security_center["security_center_deploy"] ? 1 : 0
  tier          = "Standard"
  resource_type = "Dns"
}

# Security Center Subscription Pricing (Containers)
resource "azurerm_security_center_subscription_pricing" "security_center_containers" {
  count         = var.security_center["security_center_deploy"] ? 1 : 0
  tier          = "Standard"
  resource_type = "Containers"
}

# Security Center Subscription Pricing (KeyVaults)
resource "azurerm_security_center_subscription_pricing" "security_center_key_vaults" {
  count         = var.security_center["security_center_deploy"] ? 1 : 0
  tier          = "Standard"
  resource_type = "KeyVaults"
}

# Security Center Subscription Pricing (Virtual Machines)
resource "azurerm_security_center_subscription_pricing" "security_center_virtual_machines" {
  count         = var.security_center["security_center_deploy"] ? 1 : 0
  tier          = "Standard"
  resource_type = "VirtualMachines"
}

# Security Center Subscription Pricing Sql Server Virtual Machines)
resource "azurerm_security_center_subscription_pricing" "security_center_sql_server_virtual_machines" {
  count         = var.security_center["security_center_deploy"] ? 1 : 0
  tier          = "Standard"
  resource_type = "SqlServerVirtualMachines"
}

# Security Center Subscription Pricing Sql Servers)
resource "azurerm_security_center_subscription_pricing" "security_center_sql_servers" {
  count         = var.security_center["security_center_deploy"] ? 1 : 0
  tier          = "Standard"
  resource_type = "SqlServers"
}

# Security Center Subscription Pricing Open Source Relational Databases)
resource "azurerm_security_center_subscription_pricing" "security_center_open_source_relational_databases" {
  count         = var.security_center["security_center_deploy"] ? 1 : 0
  tier          = "Standard"
  resource_type = "OpenSourceRelationalDatabases"
}

# Security Center Subscription Pricing Storage Accounts)
resource "azurerm_security_center_subscription_pricing" "security_center_storage_accounts" {
  count         = var.security_center["security_center_deploy"] ? 1 : 0
  tier          = "Standard"
  resource_type = "StorageAccounts"
}