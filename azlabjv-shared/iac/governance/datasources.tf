data "azurerm_client_config" "current" {
}

data "local_file" "parameters_content" {
  for_each = { for key, value in var.policy_details_with_params : key => value if(lookup(value, "parameters_content", null) != null) }
  filename = each.value.parameters_content
}
