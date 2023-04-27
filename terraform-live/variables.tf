variable "policy_rule" {
  type = object({
    if   = map(any)
    then = map(any)
  })
  # type = map(any)
  default = {
    "if" : {
      "not" : {
        "field" : "location",
        "equals" : "eastus"
      }
    },
    "then" : {
      "effect" : "Deny"
    }
  }
}
variable "policy_rules" {
  type = list(object({
    name         = string
    display_name = string
    parameters   = map(any)
    policy_rule = object({
      if   = map(any)
      then = map(any)
    })
  }))
  default = [{
    name : "only-deploy-in-list"
    display_name = "Allowed resource types list"
    parameters = {
      "listOfAllowedLocations" : {
        "type" : "string",
        "metadata" : {
          "description" : "The list of locations that resource groups can be created in.",
          "strongType" : "location",
          "displayName" : "Allowed locations"
        }
        "defaultValue" : "eastus"
      }
    }
    policy_rule = {
      "if" : {
        "not" : {
          "field" : "location",
          "equals" : "[parameters('listOfAllowedLocations')]"
        }
      },
      "then" : {
        "effect" : "Deny"
      }
    }
  }]
}