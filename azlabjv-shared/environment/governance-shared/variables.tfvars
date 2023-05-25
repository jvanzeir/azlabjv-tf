####################
# GLOBAL VARIABLES #
####################
# The provider variables need to be set here or in TF Cloud
provider_tenant_id       = "25b1f34f-8e86-48bd-a1c5-6953081e059a"
provider_subscription_id = "b7ac2fda-effc-4fda-b5f9-9652f4f93e20"
provider_client_id       = ""
provider_client_secret   = ""

environment = {
  name = "shared"
}

default_tags = {
  deployment_type = "terraform"
  env             = "shared"
}

##############################
# MANAGEMENT GROUP VARIABLES #
##############################
management_group = {
  name         = "SharedServicesMgmtGroup"
  display_name = "Shared Services Management Group"
}

####################
# POLICY VARIABLES #
####################
policy_default_data = {
  management_group_id    = "/providers/microsoft.management/managementGroups/SharedServicesMgmtGroup"
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
    parameters_content     = "../../environment/governance-shared/parameters_content/allowed_locations.json"
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
}