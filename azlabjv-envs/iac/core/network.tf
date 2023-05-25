locals {
  secured_subnets = toset([for snet_key, snet in var.network_subnets : snet_key if snet.use_nsg])
}

# VNet
resource "azurerm_virtual_network" "network_vnet" {
  name                = "${var.environment["company"]}-${var.environment["name"]}-${var.environment["location_shortcut"]}-vnet"
  resource_group_name = azurerm_resource_group.network_rg.name
  location            = azurerm_resource_group.network_rg.location
  address_space       = [var.network_vnet["vnet_range"]]
  tags                = var.default_tags
}

# Subnets
resource "azurerm_subnet" "network_subnet" {
  for_each             = var.network_subnets
  name                 = "${each.key}Subnet"
  address_prefixes     = [each.value["subnet_range"]]
  resource_group_name  = azurerm_resource_group.network_rg.name
  virtual_network_name = azurerm_virtual_network.network_vnet.name
  service_endpoints    = each.value["service_endpoints"] != "" ? split(",", each.value["service_endpoints"]) : null
  enforce_private_link_endpoint_network_policies = each.value["enforce_pe"]
}

# Network Security Group
resource "azurerm_network_security_group" "network_nsg" {
  for_each            = local.secured_subnets
  name                = "${lower(each.key)}-${var.environment["name"]}-${var.environment["location_shortcut"]}-nsg"
  resource_group_name = azurerm_resource_group.network_rg.name
  location            = azurerm_resource_group.network_rg.location
  tags                = var.default_tags
}

resource "azurerm_subnet_network_security_group_association" "network_subnet_nsg_association" {
  for_each                  = local.secured_subnets
  subnet_id                 = azurerm_subnet.network_subnet[each.key].id
  network_security_group_id = azurerm_network_security_group.network_nsg[each.key].id

  depends_on = [
    azurerm_network_security_rule.network_security_rule
  ]
}

# Network Security Rules
resource "azurerm_network_security_rule" "network_security_rule" {
  for_each                     = var.network_security_rules
  priority                     = each.value["priority"]
  name                         = each.value["name"]
  access                       = each.value["access"]
  direction                    = each.value["direction"]
  protocol                     = each.value["protocol"]
  source_port_range            = each.value["source_port_range"] != "" ?  each.value["source_port_range"] : null
  source_port_ranges           = each.value["source_port_ranges"] != "" ?  split(",", each.value["source_port_ranges"]) : null
  source_address_prefix        = each.value["source_address_prefix"] != "" ?  each.value["source_address_prefix"] : null
  source_address_prefixes      = each.value["source_address_prefixes"] != "" ?  split(",", each.value["source_address_prefixes"]) : null
  destination_port_range       = each.value["destination_port_range"] != "" ?  each.value["destination_port_range"] : null
  destination_port_ranges      = each.value["destination_port_ranges"] != "" ?  split(",", each.value["destination_port_ranges"]) : null
  destination_address_prefix   = each.value["destination_address_prefix"] != "" ?  each.value["destination_address_prefix"] : null
  destination_address_prefixes = each.value["destination_address_prefixes"] != "" ?  split(",", each.value["destination_address_prefixes"]) : null
  resource_group_name          = azurerm_resource_group.network_rg.name
  network_security_group_name  = "${lower(each.value["network_subnet"])}-${var.environment["name"]}-${var.environment["location_shortcut"]}-nsg"
}

# VNet Peerings
resource "azurerm_virtual_network_peering" "network_peering1" {
  name                         = "${azurerm_virtual_network.network_vnet.name}-${data.azurerm_virtual_network.network_shared.name}"
  resource_group_name          = azurerm_resource_group.network_rg.name
  virtual_network_name         = azurerm_virtual_network.network_vnet.name
  remote_virtual_network_id    = data.azurerm_virtual_network.network_shared.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = true
}

resource "azurerm_virtual_network_peering" "network_peering2" {
  provider                     = azurerm.azure_shared
  name                         = "${data.azurerm_virtual_network.network_shared.name}-${azurerm_virtual_network.network_vnet.name}"
  resource_group_name          = data.azurerm_virtual_network.network_shared.resource_group_name
  virtual_network_name         = data.azurerm_virtual_network.network_shared.name
  remote_virtual_network_id    = azurerm_virtual_network.network_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
}