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

##############################
# MANAGEMENT GROUP VARIABLES #
##############################
variable "management_group" {
  type = map(string)
}

####################
# POLICY VARIABLES #
####################
variable "policy_default_data" {
  type        = map(string)
  description = "Parameters applied to all policies if not specified"
}

variable "policy_details_with_params" {
  type        = map(map(string))
  description = "Policy details vars with params"
}
