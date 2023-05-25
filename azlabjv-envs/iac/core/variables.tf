####################
# GLOBAL VARIABLES #
####################
variable "provider_tenant_id" {}
variable "provider_subscription_id" {}
variable "provider_client_id" {}
variable "provider_client_secret" {}
variable "provider_shared_tenant_id" {}
variable "provider_shared_subscription_id" {}
variable "provider_shared_client_id" {}
variable "provider_shared_client_secret" {}

variable "environment" {
  type = map(string)
}

variable "default_tags" {
  type = map(string)
}

#####################
# NETWORK VARIABLES #
#####################

variable "network_vnet" {
  type = map(string)
}

variable "network_subnets" {
  type = map(map(string))
}

variable "network_security_rules" {
  type = map(map(string))
}

######################
# FIREWALL VARIABLES #
######################
variable "firewall" {
  type = map(string)
}

#################
# AKS VARIABLES #
#################
variable "aks_cluster" {
  type = map(string)
}

variable "aks_nodepool_services" {
  type = map(string)
}

###########################
# LOG ANALYTICS VARIABLES #
###########################
variable "log_analytics_workspace" {
  type = map(string)
}

#########################
# APP GATEWAY VARIABLES #
#########################
variable "app_gateway" {
  type = map(string)
}

#############################
# SECURITY CENTER VARIABLES #
#############################
variable "security_center" {
  type = map(string)
}