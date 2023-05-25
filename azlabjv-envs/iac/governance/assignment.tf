# Assignments
resource "azurerm_management_group_policy_assignment" "azure_policy_assignments_with_params" {
  for_each             = var.policy_details_with_params
  name                 = each.value["assignment_name"]
  management_group_id  = lookup(each.value, "management_group_id", var.policy_default_data["management_group_id"])
  policy_definition_id = each.value["policy_definition_id"]
  description          = lookup(each.value, "assignment_description", var.policy_default_data["assignment_description"])
  display_name         = each.value["assignment_displayname"]
  parameters           = lookup(data.local_file.parameters_content, each.key, null) != null ? lookup(data.local_file.parameters_content, each.key, null).content : null
}