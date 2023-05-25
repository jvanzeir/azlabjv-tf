####################
# GLOBAL VARIABLES #
####################
# The provider variables need to be set here or in TF Cloud
provider_tenant_id       = "25b1f34f-8e86-48bd-a1c5-6953081e059a"
provider_subscription_id = "60b492a4-0308-4100-9bf2-aa81b95f227a"
provider_client_id       = ""
provider_client_secret   = ""

environment = {
  name = "test"
}

default_tags = {
  deployment_type = "terraform"
  env             = "test"
}

##############################
# MANAGEMENT GROUP VARIABLES #
##############################
management_group = {
  name         = "TestMgmtGroup"
  display_name = "Test Management Group"
}

####################
# POLICY VARIABLES #
####################
policy_default_data = {
  management_group_id    = "/providers/microsoft.management/managementGroups/TestMgmtGroup"
  assignment_description = "Assigned by Customer"
}

policy_details_with_params = {
  allowed_locations = {
    assignment_displayname = "Allowed Locations"
    assignment_name        = "allowedlocations"
    policy_displayname     = "Allowed Locations"
    policy_name            = "allowedlocations"
    policy_mode            = "Indexed"
    policy_definition_id   = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"
    metadata_category      = "Customer"
    parameters_content     = "../../environment/governance-test/parameters_content/allowed_locations.json"
  }
  require_aks_policy_addon = {
    assignment_displayname = "Azure Policy Add-on for Kubernetes service (AKS)"
    assignment_name        = "requireaksaddon"
    policy_displayname     = "Azure Policy Add-on for Kubernetes service (AKS)"
    policy_name            = "requireaksaddon"
    policy_mode            = "Indexed"
    policy_definition_id   = "/providers/Microsoft.Authorization/policyDefinitions/0a15ec92-a229-4763-bb14-0ea34a568f8d"
    metadata_category      = "Customer"
  }
  require_ssh_keys_for_linux_vm = {
    assignment_displayname = "Require SSH Keys for Linux VMs"
    assignment_name        = "requiresshkeyslinuxvm"
    policy_displayname     = "Require SSH Keys for Linux VMs"
    policy_name            = "requiresshkeyslinuxvm"
    policy_mode            = "All"
    policy_definition_id   = "/providers/Microsoft.Authorization/policyDefinitions/630c64f9-8b6b-4c64-b511-6544ceff6fd6"
    metadata_category      = "Customer"
  }
  require_storageaccount_secure_transfer = {
    assignment_displayname = "Require Storage Account Secure Transfer"
    assignment_name        = "requirestasectransfer"
    policy_displayname     = "Require Storage Account Secure Transfer"
    policy_name            = "requirestasectransfer"
    policy_mode            = "Indexed"
    policy_definition_id   = "/providers/Microsoft.Authorization/policyDefinitions/404c3081-a854-4457-ae30-26a93ef643f9"
    metadata_category      = "Customer"
  }
  require_storageaccount_cmk_encryption = {
    assignment_displayname = "Require Storage Account customer-managed Key for Encryption"
    assignment_name        = "requirestacmkencr"
    policy_displayname     = "Require Storage Account customer-managed Key for Encryption"
    policy_name            = "requirestacmkencr"
    policy_mode            = "Indexed"
    policy_definition_id   = "/providers/Microsoft.Authorization/policyDefinitions/6fac406b-40ca-413b-bf8e-0bf964659c25"
    metadata_category      = "Customer"
  }
  require_storageaccount_private_link = {
    assignment_displayname = "Require Storage Account Private Link"
    assignment_name        = "requirestapl"
    policy_displayname     = "Require Storage Account Private Link"
    policy_name            = "requirestapl"
    policy_mode            = "Indexed"
    policy_definition_id   = "/providers/Microsoft.Authorization/policyDefinitions/6edd7eda-6dd8-40f7-810d-67160c639cd9"
    metadata_category      = "Customer"
  }
  require_mssql_cmk_encryption = {
    assignment_displayname = "Require MS SQL customer-managed Key for Encryption"
    assignment_name        = "requiremssqlcmkencr"
    policy_displayname     = "Require MS SQL customer-managed Key for Encryption"
    policy_name            = "requiremssqlcmkencr"
    policy_mode            = "Indexed"
    policy_definition_id   = "/providers/Microsoft.Authorization/policyDefinitions/0d134df8-db83-46fb-ad72-fe0c9428c8dd"
    metadata_category      = "Customer"
  }  
  require_mssql_private_link = {
    assignment_displayname = "Require MS SQL Private Link"
    assignment_name        = "requiremssqlpl"
    policy_displayname     = "Require MS SQL Private Link"
    policy_name            = "requiremssqlpl"
    policy_mode            = "Indexed"
    policy_definition_id   = "/providers/Microsoft.Authorization/policyDefinitions/7698e800-9299-47a6-b3b6-5a0fee576eed"
    metadata_category      = "Customer"
  }
  require_postgresql_cmk_encryption = {
    assignment_displayname = "Require PostgreSQL customer-managed Key for Encryption"
    assignment_name        = "requirepostgresqlcmkencr"
    policy_displayname     = "Require PostgreSQL customer-managed Key for Encryption"
    policy_name            = "requirepostgresqlcmkencr"
    policy_mode            = "Indexed"
    policy_definition_id   = "/providers/Microsoft.Authorization/policyDefinitions/18adea5e-f416-4d0f-8aa8-d24321e3e274"
    metadata_category      = "Customer"
  }
  require_postgresql_private_link = {
    assignment_displayname = "Require PostgreSQL Private Link"
    assignment_name        = "requirepostgresqlpl"
    policy_displayname     = "Require PostgreSQL Private Link"
    policy_name            = "requirepostgresqlpl"
    policy_mode            = "Indexed"
    policy_definition_id   = "/providers/Microsoft.Authorization/policyDefinitions/0564d078-92f5-4f97-8398-b9f58a51f70b"
    metadata_category      = "Customer"
  }
  require_eventhub_private_link = {
    assignment_displayname = "Require Eventhub Private Link"
    assignment_name        = "requireeventhubpl"
    policy_displayname     = "Require Eventhub Private Link"
    policy_name            = "requireeventhubpl"
    policy_mode            = "Indexed"
    policy_definition_id   = "/providers/Microsoft.Authorization/policyDefinitions/b8564268-eb4a-4337-89be-a19db070c59d"
    metadata_category      = "Customer"
  }
}