####################
# GLOBAL VARIABLES #
####################
# The provider variables need to be set here or in TF Cloud
provider_tenant_id       = "25b1f34f-8e86-48bd-a1c5-6953081e059a"
provider_subscription_id = "b7ac2fda-effc-4fda-b5f9-9652f4f93e20"
provider_client_id       = ""
provider_client_secret   = ""

environment = {
  company           = "customer"
  location          = "Switzerland North"
  location_shortcut = "chn"
  name              = "shared"
}

default_tags = {
  deployment_type = "terraform"
  env             = "shared"
}

#####################
# NETWORK VARIABLES #
#####################
network_vnet = {
  vnet_prefix = "shared"
  vnet_range  = "10.0.0.0/24"
}

network_subnets = {
  Gateway = {
    subnet_range = "10.0.0.0/26"
    use_nsg      = false
  },
  AzureFirewall = {
    subnet_range = "10.0.0.64/26"
    use_nsg      = false
  },
  AzureBastion = {
    subnet_range = "10.0.0.128/26"
    use_nsg      = true
  }
}

network_security_rules = {
  AzureBastionInBound100 = {
    priority                     = 100
    name                         = "AllowHttpsInBound"
    access                       = "Allow"
    direction                    = "Inbound"
    protocol                     = "Tcp"
    source_port_range            = "*"
    source_port_ranges           = ""
    source_address_prefix        = "Internet"
    source_address_prefixes      = ""
    destination_port_range       = "443"
    destination_port_ranges      = ""
    destination_address_prefix   = "*"
    destination_address_prefixes = ""
    network_subnet               = "AzureBastion"
  },
  AzureBastionInBound200 = {
    priority                     = 200
    name                         = "AllowGatewayManagerInBound"
    access                       = "Allow"
    direction                    = "Inbound"
    protocol                     = "Tcp"
    source_port_range            = "*"
    source_port_ranges           = ""
    source_address_prefix        = "GatewayManager"
    source_address_prefixes      = ""
    destination_port_range       = "443"
    destination_port_ranges      = ""
    destination_address_prefix   = "*"
    destination_address_prefixes = ""
    network_subnet               = "AzureBastion"
  },
  AzureBastionInBound300 = {
    priority                     = 300
    name                         = "AllowAzureLoadBalancerInBound"
    access                       = "Allow"
    direction                    = "Inbound"
    protocol                     = "Tcp"
    source_port_range            = "*"
    source_port_ranges           = ""
    source_address_prefix        = "AzureLoadBalancer"
    source_address_prefixes      = ""
    destination_port_range       = "443"
    destination_port_ranges      = ""
    destination_address_prefix   = "*"
    destination_address_prefixes = ""
    network_subnet               = "AzureBastion"
  },
  AzureBastionInBound400 = {
    priority                     = 400
    name                         = "AllowBastionHostComInBound8080"
    access                       = "Allow"
    direction                    = "Inbound"
    protocol                     = "*"
    source_port_range            = "*"
    source_port_ranges           = ""
    source_address_prefix        = "VirtualNetwork"
    source_address_prefixes      = ""
    destination_port_range       = "8080"
    destination_port_ranges      = ""
    destination_address_prefix   = "VirtualNetwork"
    destination_address_prefixes = ""
    network_subnet               = "AzureBastion"
  },
  AzureBastionInBound500 = {
    priority                     = 500
    name                         = "AllowBastionHostComInBound5701"
    access                       = "Allow"
    direction                    = "Inbound"
    protocol                     = "*"
    source_port_range            = "*"
    source_port_ranges           = ""
    source_address_prefix        = "VirtualNetwork"
    source_address_prefixes      = ""
    destination_port_range       = "5701"
    destination_port_ranges      = ""
    destination_address_prefix   = "VirtualNetwork"
    destination_address_prefixes = ""
    network_subnet               = "AzureBastion"
  },
  AzureBastionOutBound100 = {
    priority                     = 100
    name                         = "AllowSshOutBound"
    access                       = "Allow"
    direction                    = "Outbound"
    protocol                     = "*"
    source_port_range            = "*"
    source_port_ranges           = ""
    source_address_prefix        = "*"
    source_address_prefixes      = ""
    destination_port_range       = "22"
    destination_port_ranges      = ""
    destination_address_prefix   = "VirtualNetwork"
    destination_address_prefixes = ""
    network_subnet               = "AzureBastion"
  },
  AzureBastionOutBound200 = {
    priority                     = 200
    name                         = "AllowRdpOutBound"
    access                       = "Allow"
    direction                    = "Outbound"
    protocol                     = "*"
    source_port_range            = "*"
    source_port_ranges           = ""
    source_address_prefix        = "*"
    source_address_prefixes      = ""
    destination_port_range       = "3389"
    destination_port_ranges      = ""
    destination_address_prefix   = "VirtualNetwork"
    destination_address_prefixes = ""
    network_subnet               = "AzureBastion"
  },
  AzureBastionOutBound300 = {
    priority                     = 300
    name                         = "AllowAzureCloudOutBound"
    access                       = "Allow"
    direction                    = "Outbound"
    protocol                     = "Tcp"
    source_port_range            = "*"
    source_port_ranges           = ""
    source_address_prefix        = "*"
    source_address_prefixes      = ""
    destination_port_range       = "443"
    destination_port_ranges      = ""
    destination_address_prefix   = "AzureCloud"
    destination_address_prefixes = ""
    network_subnet               = "AzureBastion"
  },
  AzureBastionOutBound400 = {
    priority                     = 400
    name                         = "AllowBastionHostComOutBound8080"
    access                       = "Allow"
    direction                    = "Outbound"
    protocol                     = "*"
    source_port_range            = "*"
    source_port_ranges           = ""
    source_address_prefix        = "VirtualNetwork"
    source_address_prefixes      = ""
    destination_port_range       = "8080"
    destination_port_ranges      = ""
    destination_address_prefix   = "VirtualNetwork"
    destination_address_prefixes = ""
    network_subnet               = "AzureBastion"
  },
  AzureBastionOutBound500 = {
    priority                     = 500
    name                         = "AllowBastionHostComOutBound5701"
    access                       = "Allow"
    direction                    = "Outbound"
    protocol                     = "*"
    source_port_range            = "*"
    source_port_ranges           = ""
    source_address_prefix        = "VirtualNetwork"
    source_address_prefixes      = ""
    destination_port_range       = "5701"
    destination_port_ranges      = ""
    destination_address_prefix   = "VirtualNetwork"
    destination_address_prefixes = ""
    network_subnet               = "AzureBastion"
  },
  AzureBastionOutBound600 = {
    priority                     = 600
    name                         = "AllowGetSessionInformation"
    access                       = "Allow"
    direction                    = "Outbound"
    protocol                     = "*"
    source_port_range            = "*"
    source_port_ranges           = ""
    source_address_prefix        = "*"
    source_address_prefixes      = ""
    destination_port_range       = "80"
    destination_port_ranges      = ""
    destination_address_prefix   = "Internet"
    destination_address_prefixes = ""
    network_subnet               = "AzureBastion"
  }
}

#####################
# S2S-VPN VARIABLES #
#####################
vpn_gateway = {
  vpn_deploy    = false
  vpn_type      = "RouteBased"
  active_active = false
  enable_bgp    = false
  sku           = "VpnGw1"
}

local_gateway = {
  name            = "zurich"
  gateway_address = "138.190.10.52"
}

local_gateway_addresses = [
  "172.16.0.0/12",
  "192.168.0.0/16"
]

##########################
# EXPRESSROUTE VARIABLES #
##########################
expressroute_circuit = {
  service_provider_name = "Swisscom"
  peering_location      = "Zurich"
  bandwidth_in_mbps     = 200
}

expressroute_gateway = {
  er_deploy     = false
  vpn_type      = "RouteBased"
  active_active = false
  enable_bgp    = false
  sku           = "Standard"
}

#########################
# ROUTE TABLE VARIABLES #
#########################
route_table = {
  prefix_test = "10.0.1.0/24"
  prefix_int  = "10.0.2.0/24"
  prefix_prod = "10.0.3.0/24"
}

######################
# FIREWALL VARIABLES #
######################
firewall = {
  firewall_deploy         = false
  prefix                  = "firewall"
  pip_sku                 = "Standard"
  pip_allocation_method   = "Static"
  diagnostics_retention   = 30
}

firewall_policy = {
  sku                      = "Standard"
  threat_intelligence_mode = "Alert"
  dns_proxy_enabled        = true
  dns_servers              = "" # comma separated list
}

firewall_nat_rc01 = [
  {
    name                  = "RemoteToJumphost"
    protocols             = "TCP"
    source_addresses      = "*"
    destination_address   = "" # if empty, the Azure Firewall public IP is taken
    destination_ports     = "3389"
    translated_address    = "10.0.1.200"
    translated_port       = "3389"
  }
]

firewall_network_test_rc01 = [
  {
    name                  = "AllowAnyToTest"
    protocols             = "Any"
    source_addresses      = "172.16.0.0/12,192.168.0.0/16"
    destination_addresses = "10.0.1.0/24"
    destination_fqdns     = ""
    destination_ports     = "*"
  },
  {
    name                  = "AllowAnyToOnprem"
    protocols             = "Any"
    source_addresses      = "10.0.1.0/24"
    destination_addresses = "172.16.0.0/12,192.168.0.0/16"
    destination_fqdns     = ""  
    destination_ports     = "*"
  }
]

firewall_network_int_rc01 = [
  {
    name                  = "AllowAnyToInt"
    protocols             = "Any"
    source_addresses      = "172.16.0.0/12,192.168.0.0/16"
    destination_addresses = "10.0.2.0/24"
    destination_fqdns     = ""
    destination_ports     = "*"
  },
  {
    name                  = "AllowAnyToOnprem"
    protocols             = "Any"
    source_addresses      = "10.0.2.0/24"
    destination_addresses = "172.16.0.0/12,192.168.0.0/16"
    destination_fqdns     = ""  
    destination_ports     = "*"
  }
]

firewall_network_prod_rc01 = [
  {
    name                  = "AllowAnyToProd"
    protocols             = "Any"
    source_addresses      = "172.16.0.0/12,192.168.0.0/16"
    destination_addresses = "10.0.3.0/24"
    destination_fqdns     = ""
    destination_ports     = "*"
  },
  {
    name                  = "AllowAnyToOnprem"
    protocols             = "Any"
    source_addresses      = "10.0.3.0/24"
    destination_addresses = "172.16.0.0/12,192.168.0.0/16"
    destination_fqdns     = ""  
    destination_ports     = "*"
  }
]

firewall_application_rc01 = [
  {
    name                  = "Azure"
    source_addresses      = "*"
    destination_fqdns     = ""
    destination_fqdn_tags = "AzureBackup,AzureKubernetesService,MicrosoftActiveProtectionService,WindowsDiagnostics,WindowsUpdate"
    protocol_http         = "Http"
    port_http             = "80"
    protocol_https        = "Https"
    port_https            = "443"
  }
]

#####################
# BASTION VARIABLES #
#####################
bastion = {
  bastion_deploy          = false
  prefix                  = "bastion"
  pip_sku                 = "Standard"
  pip_allocation_method   = "Static"
}

################################
# CONTAINER REGISTRY VARIABLES #
################################
container_registry = {
  container_registry_deploy = false
  name                      = "customer"
  sku                       = "Standard"
  georeplication_location   = "Switzerland West"
  content_trust             = false #https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry#trust_policy
}

###########################
# LOG ANALYTICS VARIABLES #
###########################
log_analytics_workspace = {
  sku               = "PerGB2018"
  retention_in_days = 30
}

#############################
# SECURITY CENTER VARIABLES #
#############################
security_center = {
  security_center_deploy = false
}