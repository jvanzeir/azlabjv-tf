# Resource Group Azure Kubernetes Service
resource "azurerm_resource_group" "aks_rg" {
  count    = var.aks_cluster["aks_cluster_deploy"] ? 1 : 0
  name     = "aks-${var.environment["name"]}-${var.environment["location_shortcut"]}-rg"
  location = var.environment["location"]
  tags     = var.default_tags
}

# User-assigned identity Azure Kubernetes Service
resource "azurerm_user_assigned_identity" "aks_user_assigned_identity" {
  count                   = var.aks_cluster["aks_cluster_deploy"] ? 1 : 0
  resource_group_name     = azurerm_resource_group.aks_rg[0].name
  location                = azurerm_resource_group.aks_rg[0].location
  name                    = "aks-${var.environment["name"]}-${var.environment["location_shortcut"]}-msi"
  tags                    = var.default_tags
}

resource "azurerm_role_assignment" "contributor_role_assignment_network_rg" {
  count                            = var.aks_cluster["aks_cluster_deploy"] ? 1 : 0
  scope                            = azurerm_resource_group.network_rg.id
  role_definition_name             = "Network Contributor"
  principal_id                     = azurerm_user_assigned_identity.aks_user_assigned_identity[0].principal_id
}

# Azure Kubernetes Service
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  count                   = var.aks_cluster["aks_cluster_deploy"] ? 1 : 0
  name                    = "${var.aks_cluster["name"]}-${var.environment["name"]}-${var.environment["location_shortcut"]}-aks"
  resource_group_name     = azurerm_resource_group.aks_rg[0].name
  location                = azurerm_resource_group.aks_rg[0].location
  dns_prefix              = "${var.aks_cluster["name"]}-${var.environment["name"]}-${var.environment["location_shortcut"]}-aks-dns"
  kubernetes_version      = var.aks_cluster["k8s_version"]
  node_resource_group     = "aksnodes-${var.environment["name"]}-${var.environment["location_shortcut"]}-rg"
  tags                    = var.default_tags

  private_cluster_enabled = false
  api_server_authorized_ip_ranges = var.aks_cluster["authorized_ip_ranges"] != "" ?  split(",", var.aks_cluster["authorized_ip_ranges"]) : null

  addon_profile {
    oms_agent {
      enabled = var.aks_cluster["enable_oms_agent"]
      log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id
    }
    azure_policy {
      enabled = var.aks_cluster["enable_azure_policy"]
    }
    ingress_application_gateway {
      enabled = var.aks_cluster["enable_ingress_application_gateway"]
      gateway_id = var.aks_cluster["enable_ingress_application_gateway"] ? azurerm_application_gateway.app_gateway[0].id : null
    }
    http_application_routing {
      enabled = var.aks_cluster["enable_http_application_routing"]
    }
  }

  identity {
    type = "UserAssigned"
    user_assigned_identity_id = azurerm_user_assigned_identity.aks_user_assigned_identity[0].id
  }

  default_node_pool {
    name                 = var.aks_cluster["default_node_pool_name"]
    node_count           = var.aks_cluster["default_node_count"]
    vm_size              = var.aks_cluster["default_node_vm_size"]
    type                 = "VirtualMachineScaleSets"
    os_disk_size_gb      = var.aks_cluster["default_os_disk_size_gb"]
    vnet_subnet_id       = azurerm_subnet.network_subnet["AKS"].id
  }

  network_profile {
    network_plugin     = var.aks_cluster["network_plugin"]
    network_policy     = var.aks_cluster["network_policy"]
    load_balancer_sku  = var.aks_cluster["load_balancer_sku"]
    outbound_type      = var.firewall["firewall_deploy"] ? "userDefinedRouting" : "loadBalancer"
    service_cidr       = var.aks_cluster["service_cidr"]
    dns_service_ip     = cidrhost(var.aks_cluster["service_cidr"], 10)
    docker_bridge_cidr = var.aks_cluster["docker_bridge_cidr"]
  }

  role_based_access_control {
    enabled = true
  }
  
  depends_on = [
    azurerm_user_assigned_identity.aks_user_assigned_identity,
    azurerm_role_assignment.contributor_role_assignment_network_rg
  ]
}

resource "azurerm_kubernetes_cluster_node_pool" "nodepool_services" {
  count                 = var.aks_cluster["aks_cluster_deploy"] ? 1 : 0
  name                  = var.aks_nodepool_services["node_pool_name"]
  node_count            = var.aks_nodepool_services["node_count"]
  vm_size               = var.aks_nodepool_services["node_vm_size"]
  os_disk_size_gb       = var.aks_nodepool_services["os_disk_size_gb"]
  max_pods              = var.aks_nodepool_services["max_pods"]
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks_cluster[0].id
  vnet_subnet_id        = azurerm_subnet.network_subnet["AKS"].id
  tags                  = var.default_tags
}