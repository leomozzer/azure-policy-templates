data "azurerm_subscription" "current" {}

data "azurerm_management_group" "name" {
  display_name = "lso-management-group"
}

# locals {
#   for_each = {
#     for index, policy in var.subscription_policy_rules : policy => policy
#   }
#   //policy = jsondecode(file("../policy/ResourceGroupAndLogAnalyticsToCentralizeMonitoring.json"))
# }

# output "some" {
#   value = local.policy.properties.description
# }

module "subscription_policy" {
  source = "../terraform-modules/policy-subscription-json-file"
  for_each = {
    for index, policy in var.subscription_policy_rules : policy.name => policy
  }
  policy_definition_name     = each.value.name
  create_assignment          = each.value.create_assignment
  file_name                  = each.value.file_name
  policy_definition_location = each.value.location
}

# module "subscription_policy" {
#   source = "../terraform-modules/policy-subscription"
#   for_each = {
#     for index, policy in var.subscription_policy_rules : policy.name => policy
#   }

#   policy_definition_name         = each.value.name
#   policy_definition_display_name = each.value.display_name
#   policy_definition_description  = each.value.description
#   policy_definition_metadata     = tostring(jsonencode(each.value.metadata))
#   policy_definition_policy_rule  = tostring(jsonencode(each.value.policy_rule))
#   policy_definition_parameters   = tostring(jsonencode(each.value.parameters))
#   create_assignment              = each.value.create_assignment
#   policy_definition_location     = each.value.location
# }

# resource "azurerm_policy_definition" "example" {
#   for_each = {
#     for index, policy in var.subscription_policy_rules : policy.name => policy
#   }
#   name         = each.value.name
#   policy_type  = "Custom"
#   mode         = "All"
#   display_name = each.value.display_name

#   metadata = tostring(jsonencode(each.value.metadata))

#   policy_rule = tostring(jsonencode(each.value.policy_rule))

#   parameters = tostring(jsonencode(each.value.parameters))

#   #management_group_id = data.azurerm_management_group.name.id

# }

# resource "azurerm_subscription_policy_assignment" "example" {
#   for_each = {
#     for index, policy in var.policy_rules : policy.name => policy
#   }
#   name                 = "${each.value.name}-assignment"
#   policy_definition_id = azurerm_policy_definition.example[each.value.name].id
#   subscription_id      = data.azurerm_subscription.current.id

#   identity {
#     type = "SystemAssigned"
#   }
# }

# resource "azurerm_management_group_policy_assignment" "example" {
#   for_each = {
#     for index, policy in var.policy_rules : policy.name => policy
#   }
#   name                 = "magr-assignment"
#   policy_definition_id = azurerm_policy_definition.example[each.value.name].id
#   management_group_id  = data.azurerm_management_group.name.id
# }