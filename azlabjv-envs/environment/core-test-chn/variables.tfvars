####################
# GLOBAL VARIABLES #
####################
# The provider variables need to be set here or in TF Cloud
provider_tenant_id              = "25b1f34f-8e86-48bd-a1c5-6953081e059a"
provider_subscription_id        = "60b492a4-0308-4100-9bf2-aa81b95f227a"
provider_client_id              = ""
provider_client_secret          = ""
provider_shared_tenant_id       = "25b1f34f-8e86-48bd-a1c5-6953081e059a"
provider_shared_subscription_id = "b7ac2fda-effc-4fda-b5f9-9652f4f93e20"
provider_shared_client_id       = ""
provider_shared_client_secret   = ""

environment = {
  company           = "customer"
  location          = "Switzerland North"
  location_shortcut = "chn"
  name              = "test"
}

default_tags = {
  deployment_type = "terraform"
  env             = "test"
}

#####################
# NETWORK VARIABLES #
#####################
network_vnet = {
  vnet_prefix = "test"
  vnet_range  = "10.0.1.0/24"
}

network_subnets = {
  AKS = {
    subnet_range      = "10.0.1.0/26"
    use_nsg           = false
    use_customrt      = true # true only if firewall_deploy is true
    service_endpoints = "" # comma separated list
    enforce_pe        = false
  },
  PrivateEndpoint = {
    subnet_range      = "10.0.1.64/26"
    use_nsg           = false
    use_customrt      = true # true only if firewall_deploy is true
    service_endpoints = "" # comma separated list
    enforce_pe        = true
  },
  AppGateway = {
    subnet_range      = "10.0.1.128/26"
    use_nsg           = false
    use_customrt      = false # must be false even if firewall_deploy is true
    service_endpoints = "" # comma separated list
    enforce_pe        = false
  },
  Main = {
    subnet_range      = "10.0.1.192/26"
    use_nsg           = true
    use_customrt      = true # true only if firewall_deploy is true
    service_endpoints = "" # comma separated list
    enforce_pe        = false
  }
}

network_security_rules = {
  AllowRdpInBound100 = {
    priority                     = 100
    name                         = "AllowRdpInBound"
    access                       = "Allow"
    direction                    = "Inbound"
    protocol                     = "TCP"
    source_port_range            = "*"
    source_port_ranges           = ""
    source_address_prefix        = "*"
    source_address_prefixes      = ""
    destination_port_range       = "3389"
    destination_port_ranges      = ""
    destination_address_prefix   = "*"
    destination_address_prefixes = ""
    network_subnet              = "Main"
  }
}

######################
# FIREWALL VARIABLES #
######################
firewall = {
  firewall_deploy = true
}

#################
# AKS VARIABLES #
#################
aks_cluster = {
  name                               = "customer"
  k8s_version                        = "1.24.6"
  load_balancer_sku                  = "Standard"
  network_plugin                     = "kubenet" # azure or kubenet
  network_policy                     = "calico"
  pod_cidr                           = "10.244.0.0/16"
  service_cidr                       = "10.100.0.0/16"
  docker_bridge_cidr                 = "172.17.0.1/16"
  default_node_pool_name             = "agentpool"
  default_node_count                 = 1
  default_node_vm_size               = "Standard_D2s_v4"
  default_os_disk_size_gb            = 128
  enable_oms_agent                   = true
  enable_azure_policy                = true
  enable_ingress_application_gateway = true # true only if app_gateway_deploy is true
  enable_http_application_routing    = false
  authorized_ip_ranges               = ""  # comma separated list
  aks_cluster_deploy                 = false
}

aks_nodepool_services = {
  node_pool_name                     = "services"
  node_count                         = 1
  node_vm_size                       = "Standard_D2s_v4"
  os_disk_size_gb                    = 128
  max_pods                           = 250
}

###########################
# LOG ANALYTICS VARIABLES #
###########################
log_analytics_workspace = {
  sku               = "PerGB2018"
  retention_in_days = 30
}

#########################
# APP GATEWAY VARIABLES #
#########################
app_gateway = {
  name                         = "customer"
  sku_name                     = "WAF_v2"
  sku_tier                     = "WAF_v2"
  autoscale_min_capacity       = 1
  autoscale_max_capacity       = 10
  pip_sku                      = "Standard"
  pip_allocation_method        = "Static"
  waf_enabled                  = true
  waf_firewall_mode            = "Detection"
  waf_rule_set_type            = "OWASP"
  waf_rule_set_version         = "3.1"
  waf_file_upload_limit_mb     = 100
  waf_request_body_check       = true
  waf_max_request_body_size_kb = 128
  app_gateway_deploy           = true
  diagnostics_retention        = 30
}

#############################
# SECURITY CENTER VARIABLES #
#############################
security_center = {
  security_center_deploy = false
}