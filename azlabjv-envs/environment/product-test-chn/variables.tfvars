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

######################
# KEYVAULT VARIABLES #
######################
key_vault = {
  name           = "product"
  sku            = "standard"
  default_action = "Deny"
  bypass         = "None" # "AzureServices" allows access to trusted Azure Services
  ip_rules       = "85.5.119.149"  # comma separated list (at least TF User)
}

##############################
# STORAGE ACCCOUNT VARIABLES #
##############################
storage_accounts = {
  "productst01" = {
    name             = "product"
    count            = "01"
    tier             = "Standard"
    replication      = "LRS"
    access           = "Hot"
    min_tls_version  = "TLS1_2"
    default_action   = "Deny"
    bypass           = "None" # comma separated list, "AzureServices" allows access to trusted Azure Services
    ip_rules         = "85.5.119.149"  # comma separated list (at least TF User)
  }
}

storage_containers = {
  "productcontainer" = {
    name                  = "productcontainer"
    container_access_type = "private"
    storage_account_name  = "productst01"
  }
}

storage_fileshares = {
  "productfileshare" = {
    name                  = "productfileshare"
    quota                 = 5120
    storage_account_name  = "productst01"
  }
}

####################
# SQL VM VARIABLES #
####################
sql_vm01 = {
  name                   = "sql-vm01"
  size                   = "Standard_D2s_v4"
  publisher              = "MicrosoftSQLServer"
  offer                  = "SQL2019-WS2019"
  sku                    = "standard"
  version                = "latest"
  data_disk_size_gb      = 128
  log_disk_size_gb       = 128
  private_ip_address     = ""
  admin_username         = "sqladmin"
  default_file_path_data = "F:/data"
  default_file_path_log  = "G:/log"
}

#######################
# AZURE SQL VARIABLES #
#######################
mssql_server = {
  name                = "product"
  version             = "12.0"
  administrator_login = "sqladmin"
  public_network_access_enabled = false
  # if firewall rules should be considered, public_network_access_enabled must be true
  # if public_network_access_enabled is false, access is only possible through private endpoints
}

mssql_database = {
  name                = "product"
  sku_name            = "GP_Gen5_2"
  max_size_gb         = "1024"
  collation           = "SQL_LATIN1_GENERAL_CP1_CI_AS"
}

########################
# POSTGRESQL VARIABLES #
########################
postgresql_server = {
  name                          = "product"
  sku_name                      = "GP_Gen5_2"
  version                       = 11
  storage_mb                    = 1024000
  backup_retention_days         = 7
  geo_redundant_backup_enabled  = false
  auto_grow_enabled             = true
  administrator_login           = "psqladmin"
  databases                     = "product" # split databases with semicolon ;
  public_network_access_enabled = false
  # if firewall rules should be considered, public_network_access_enabled must be true
  # if public_network_access_enabled is false, access is only possible through private endpoints
}

######################
# EVENTHUB VARIABLES #
######################
eventhub_ns = {
  name                            = "product"
  sku                             = "Standard"
  sku_capacity                    = 1
  default_action                  = "Deny"
  trusted_service_access_enabled  = false
  ip_mask                         = "85.5.119.149" # at least TF User
}

eventhub_hubs = {
  "producthub01" = {
    consumer_group_name = "productconsumergroup"
    partition_count     = 1
    message_retention   = 1
  }
}