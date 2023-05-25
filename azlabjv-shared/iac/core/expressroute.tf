# ExpressRoute Circuit
resource "azurerm_express_route_circuit" "expressroute_circuit" {
  count                 = var.expressroute_gateway["er_deploy"] ? 1 : 0
  name                  = "${lower(var.expressroute_circuit.peering_location)}-erc01"
  resource_group_name   = azurerm_resource_group.network_rg.name
  location              = azurerm_resource_group.network_rg.location
  service_provider_name = var.expressroute_circuit.service_provider_name
  peering_location      = var.expressroute_circuit.peering_location
  bandwidth_in_mbps     = var.expressroute_circuit.bandwidth_in_mbps

  sku {
    tier   = "Standard"
    family = "MeteredData"
  }

  tags = var.default_tags
}

# ExpressRoute Gateway
resource "azurerm_virtual_network_gateway" "expressroute_gateway" {
  count               = var.expressroute_gateway["er_deploy"] ? 1 : 0
  name                = "${var.environment["company"]}-${var.environment["name"]}-${var.environment["location_shortcut"]}-ergw"
  resource_group_name = azurerm_resource_group.network_rg.name
  location            = azurerm_resource_group.network_rg.location
  type                = "ExpressRoute"
  vpn_type            = var.expressroute_gateway.vpn_type
  active_active       = var.expressroute_gateway.active_active
  enable_bgp          = var.expressroute_gateway.enable_bgp
  sku                 = var.expressroute_gateway.sku
  tags                = var.default_tags

  ip_configuration {
    name                          = "VpnGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.expressroute_gateway_pip[0].id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.network_subnet["Gateway"].id
  }
}

# ExpressRoute Gateway Public IP
resource "azurerm_public_ip" "expressroute_gateway_pip" {
  count               = var.expressroute_gateway["er_deploy"] ? 1 : 0
  name                = "${var.environment["company"]}-${var.environment["name"]}-${var.environment["location_shortcut"]}-ergw-pip01"
  resource_group_name = azurerm_resource_group.network_rg.name
  location            = azurerm_resource_group.network_rg.location
  allocation_method   = "Dynamic"
  availability_zone   = "No-Zone"
  tags                = var.default_tags
}

# ExpressRoute Gateway Connection
resource "azurerm_virtual_network_gateway_connection" "expressroute_gateway_connection" {
  count                      = var.expressroute_gateway["er_deploy"] ? 1 : 0
  name                       = "${azurerm_virtual_network_gateway.expressroute_gateway[0].name}-${azurerm_express_route_circuit.expressroute_circuit[0].name}"
  resource_group_name        = azurerm_resource_group.network_rg.name
  location                   = azurerm_resource_group.network_rg.location
  type                       = "ExpressRoute"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.expressroute_gateway[0].id
  express_route_circuit_id   = azurerm_express_route_circuit.expressroute_circuit[0].id
  tags                       = var.default_tags
}