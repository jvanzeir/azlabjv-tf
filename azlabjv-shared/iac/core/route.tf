# Route Table
resource "azurerm_route_table" "route_table" {
  count                         = var.firewall["firewall_deploy"] ? 1 : 0
  name                          = "${var.environment["company"]}-${var.environment["name"]}-${var.environment["location_shortcut"]}-rt"
  resource_group_name           = azurerm_resource_group.network_rg.name
  location                      = azurerm_resource_group.network_rg.location
  disable_bgp_route_propagation = false
  tags                          = var.default_tags
}

# Routes
resource "azurerm_route" "route_to_test" {
  count                  = var.firewall["firewall_deploy"] ? 1 : 0
  name                   = "to-test"
  resource_group_name    = azurerm_resource_group.network_rg.name
  route_table_name       = azurerm_route_table.route_table[0].name
  address_prefix         = var.route_table["prefix_test"]
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.firewall[0].ip_configuration[0].private_ip_address
}

resource "azurerm_route" "route_to_int" {
  count                  = var.firewall["firewall_deploy"] ? 1 : 0
  name                   = "to-int"
  resource_group_name    = azurerm_resource_group.network_rg.name
  route_table_name       = azurerm_route_table.route_table[0].name
  address_prefix         = var.route_table["prefix_int"]
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.firewall[0].ip_configuration[0].private_ip_address
}

resource "azurerm_route" "route_to_prod" {
  count                  = var.firewall["firewall_deploy"] ? 1 : 0
  name                   = "to-prod"
  resource_group_name    = azurerm_resource_group.network_rg.name
  route_table_name       = azurerm_route_table.route_table[0].name
  address_prefix         = var.route_table["prefix_prod"]
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.firewall[0].ip_configuration[0].private_ip_address
}

# Route Table Association
resource "azurerm_subnet_route_table_association" "route_table_association" {
  count          = var.firewall["firewall_deploy"] ? 1 : 0
  subnet_id      = azurerm_subnet.network_subnet["Gateway"].id
  route_table_id = azurerm_route_table.route_table[0].id
}
