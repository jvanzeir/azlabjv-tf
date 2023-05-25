# VPN Gateway
resource "azurerm_virtual_network_gateway" "vpn_gateway" {
  count               = var.vpn_gateway["vpn_deploy"] ? 1 : 0
  name                = "${var.environment["company"]}-${var.environment["name"]}-${var.environment["location_shortcut"]}-vgw"
  resource_group_name = azurerm_resource_group.network_rg.name
  location            = azurerm_resource_group.network_rg.location
  type                = "Vpn"
  vpn_type            = var.vpn_gateway.vpn_type
  active_active       = var.vpn_gateway.active_active
  enable_bgp          = var.vpn_gateway.enable_bgp
  sku                 = var.vpn_gateway.sku
  tags                = var.default_tags

  ip_configuration {
    name                          = "VpnGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpn_gateway_pip[0].id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.network_subnet["Gateway"].id
  }
}

# VPN Gateway Public IP
resource "azurerm_public_ip" "vpn_gateway_pip" {
  count               = var.vpn_gateway["vpn_deploy"] ? 1 : 0
  name                = "${var.environment["company"]}-${var.environment["name"]}-${var.environment["location_shortcut"]}-vgw-pip01"
  resource_group_name = azurerm_resource_group.network_rg.name
  location            = azurerm_resource_group.network_rg.location
  allocation_method   = "Dynamic"
  availability_zone   = "No-Zone"
  tags                = var.default_tags
}

# Local Network Gateway
resource "azurerm_local_network_gateway" "local_gateway" {
  count               = var.vpn_gateway["vpn_deploy"] ? 1 : 0
  name                = "${var.local_gateway.name}-lgw01"
  resource_group_name = azurerm_resource_group.network_rg.name
  location            = azurerm_resource_group.network_rg.location
  gateway_address     = var.local_gateway.gateway_address
  address_space       = var.local_gateway_addresses
  tags                = var.default_tags
}

# VPN Gateway Connection
resource "azurerm_virtual_network_gateway_connection" "vpn_gateway_connection" {
  count                      = var.vpn_gateway["vpn_deploy"] ? 1 : 0
  name                       = "${azurerm_virtual_network_gateway.vpn_gateway[0].name}-${azurerm_local_network_gateway.local_gateway[0].name}"
  resource_group_name        = azurerm_resource_group.network_rg.name
  location                   = azurerm_resource_group.network_rg.location
  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vpn_gateway[0].id
  local_network_gateway_id   = azurerm_local_network_gateway.local_gateway[0].id
  shared_key                 = var.shared_key
  tags                       = var.default_tags
}