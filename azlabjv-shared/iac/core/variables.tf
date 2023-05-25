####################
# GLOBAL VARIABLES #
####################
variable "provider_tenant_id" {}
variable "provider_subscription_id" {}
variable "provider_client_id" {}
variable "provider_client_secret" {}

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

#####################
# S2S-VPN VARIABLES #
#####################
variable "vpn_gateway" {
  type = map(string)
}

variable "local_gateway" {
  type = map(string)
}

variable "local_gateway_addresses" {
  type = list(string)
}

variable "shared_key" {
  type = string
}

##########################
# EXPRESSROUTE VARIABLES #
##########################
variable "expressroute_circuit" {
  type = map(string)
}

variable "expressroute_gateway" {
  type = map(string)
}

#########################
# ROUTE TABLE VARIABLES #
#########################
variable "route_table" {
  type = map(string)
}

######################
# FIREWALL VARIABLES #
######################
variable "firewall" {
  type = map(string)
}

variable "firewall_policy" {
  type = map(string)
}

variable "firewall_nat_rc01" {
  type = list(map(string))
}

variable "firewall_network_test_rc01" {
  type = list(map(string))
}

variable "firewall_network_int_rc01" {
  type = list(map(string))
}

variable "firewall_network_prod_rc01" {
  type = list(map(string))
}

variable "firewall_application_rc01" {
  type = list(map(string))
}

#####################
# BASTION VARIABLES #
#####################
variable "bastion" {
  type = map(string)
}

################################
# CONTAINER REGISTRY VARIABLES #
################################
variable "container_registry" {
  type = map(string)
}

###########################
# LOG ANALYTICS VARIABLES #
###########################
variable "log_analytics_workspace" {
  type = map(string)
}

#############################
# SECURITY CENTER VARIABLES #
#############################
variable "security_center" {
  type = map(string)
}