# data "azurerm_subscription" "current" {}

# resource "azurerm_policy_definition" "example" {
#     display_name =  "some definition"
#   name        = "only-deploy-in-westeurope"
#   policy_type = "Custom"
#   mode        = "All"

#   policy_rule = <<POLICY_RULE
#  {
#     "if": {
#       "not": {
#         "field": "location",
#         "equals": "westeurope"
#       }
#     },
#     "then": {
#       "effect": "Deny"
#     }
#   }
# POLICY_RULE
# }

# resource "azurerm_resource_policy_assignment" "example" {
#   name                 = "example-policy-assignment"
#   policy_definition_id = azurerm_policy_definition.example.id
#   subscription_id      = data.azurerm_subscription.current.id
# }

data "azurerm_subscription" "current" {}

resource "azurerm_policy_definition" "example" {
  for_each = {
    for index, policy in var.policy_rules : policy.name => policy
  }
  name         = each.value.name
  policy_type  = "Custom"
  mode         = "All"
  display_name = each.value.display_name

  policy_rule = tostring(jsonencode(each.value.policy_rule))

  parameters = tostring(jsonencode(each.value.parameters))

}

resource "azurerm_subscription_policy_assignment" "example" {
  for_each = {
    for index, policy in var.policy_rules : policy.name => policy
  }
  name                 = "${each.value.name}-assignment"
  policy_definition_id = azurerm_policy_definition.example[each.value.name].id
  subscription_id      = data.azurerm_subscription.current.id
}