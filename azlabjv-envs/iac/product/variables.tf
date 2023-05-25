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

######################
# KEYVAULT VARIABLES #
######################
variable "key_vault" {
  type = map(string)
}

##############################
# STORAGE ACCCOUNT VARIABLES #
##############################
variable "storage_accounts" {
  type = map(map(string))
}

variable "storage_containers" {
  type = map(map(string))
}

variable "storage_fileshares" {
  type = map(map(string))
}

####################
# SQL VM VARIABLES #
####################
variable "sql_vm01" {
  type = map(string)
}

#######################
# AZURE SQL VARIABLES #
#######################
variable "mssql_server" {
  type = map(string)
}

variable "mssql_database" {
  type = map(string)
}

########################
# POSTGRESQL VARIABLES #
########################
variable "postgresql_server" {
  type = map(string)
}

######################
# EVENTHUB VARIABLES #
######################
variable "eventhub_ns" {
  type = map(string)
}

variable "eventhub_hubs" {
  type = map(map(string))
}