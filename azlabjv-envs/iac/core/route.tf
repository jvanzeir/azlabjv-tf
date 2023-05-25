locals {
  customrt_subnets = toset([for snet_key, snet in var.network_subnets : snet_key if snet.use_customrt])
}

# Route Table
resource "azurerm_route_table" "route_table" {
  count                         = var.firewall["firewall_deploy"] ? 1 : 0
  name                          = "${var.environment["company"]}-${var.environment["name"]}-${var.environment["location_shortcut"]}-rt"
  resource_group_name           = azurerm_resource_group.network_rg.name
  location                      = azurerm_resource_group.network_rg.location
  disable_bgp_route_propagation = true
  tags                          = var.default_tags
}

# Routes
resource "azurerm_route" "default_route" {
  count                  = var.firewall["firewall_deploy"] ? 1 : 0
  name                   = "Default"
  resource_group_name    = azurerm_resource_group.network_rg.name
  route_table_name       = azurerm_route_table.route_table[0].name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = data.azurerm_firewall.firewall_shared[0].ip_configuration[0].private_ip_address
}

# Route Table Association
resource "azurerm_subnet_route_table_association" "route_table_association" {
  for_each       = local.customrt_subnets
  subnet_id      = azurerm_subnet.network_subnet[each.key].id
  route_table_id = azurerm_route_table.route_table[0].id
}
