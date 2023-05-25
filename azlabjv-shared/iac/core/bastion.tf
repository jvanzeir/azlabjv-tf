locals {
  bastion_name = "${var.environment["company"]}-${var.environment["name"]}-${var.environment["location_shortcut"]}-bastion"
}

# Bastion Random URL
resource "random_string" "bastion_random_url" {
  count   = var.bastion["bastion_deploy"] ? 1 : 0
  length  = 8
  special = false
  upper   = false
}

# Bastion Puplic IP
resource "azurerm_public_ip" "bastion_pip" {
  count               = var.bastion["bastion_deploy"] ? 1 : 0
  name                = "${local.bastion_name}-pip01"
  resource_group_name = azurerm_resource_group.mgmt_rg.name
  location            = azurerm_resource_group.mgmt_rg.location
  sku                 = var.bastion["pip_sku"]
  allocation_method   = var.bastion["pip_allocation_method"]
  availability_zone   = "No-Zone"
  domain_name_label   = "${var.bastion["prefix"]}-${random_string.bastion_random_url[0].result}"
  tags                = var.default_tags
}

resource "azurerm_bastion_host" "bastion_host" {
  count               = var.bastion["bastion_deploy"] ? 1 : 0
  name                = local.bastion_name
  resource_group_name = azurerm_resource_group.mgmt_rg.name
  location            = azurerm_resource_group.mgmt_rg.location

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.network_subnet["AzureBastion"].id
    public_ip_address_id = azurerm_public_ip.bastion_pip[0].id
  }
}
