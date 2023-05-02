# subscription_policy_rules = [
#   {
#     name : "diagnostic-settings-centralized-law"
#     display_name = "Configure diagnostic settings for all resources to Log Analytics workspace"
#     description  = "Deploys the diagnostic settings for all resources to stream resource logs to a Log Analytics workspace when any resource which is missing this diagnostic settings is created or updated."
#     metadata = {
#       "version" : "1.0.0"
#       "category" : "Monitoring"
#     }
#     parameters = {
#       "effect" : {
#         "type" : "String",
#         "metadata" : {
#           "displayName" : "Effect",
#           "description" : "Enable or disable the execution of the policy"
#         },
#         "allowedValues" : [
#           "DeployIfNotExists",
#           "AuditIfNotExists",
#           "Disabled"
#         ],
#         "defaultValue" : "DeployIfNotExists"
#       },
#       "profileName" : {
#         "type" : "String",
#         "metadata" : {
#           "displayName" : "Profile name",
#           "description" : "The diagnostic settings profile name"
#         },
#         "defaultValue" : "AzPolicyDiagnosticSetting"
#       },
#       "logAnalytics" : {
#         "type" : "String",
#         "metadata" : {
#           "displayName" : "Log Analytics workspace",
#           "description" : "Select Log Analytics workspace from the dropdown list. If this workspace is outside of the scope of the assignment you must manually grant 'Log Analytics Contributor' permissions (or similar) to the policy assignment's principal ID.",
#           "strongType" : "omsWorkspace",
#           "assignPermissions" : true
#         }
#       },
#       "metricsEnabled" : {
#         "type" : "Boolean",
#         "metadata" : {
#           "displayName" : "Enable metrics",
#           "description" : "Whether to enable metrics stream to the Log Analytics workspace - True or False"
#         },
#         "allowedValues" : [
#           true,
#           false
#         ],
#         "defaultValue" : true
#       },
#       "logsEnabled" : {
#         "type" : "Boolean",
#         "metadata" : {
#           "displayName" : "Enable logs",
#           "description" : "Whether to enable logs stream to the Log Analytics workspace - True or False"
#         },
#         "allowedValues" : [
#           true,
#           false
#         ],
#         "defaultValue" : true
#       }
#     }
#     policy_rule = {
#       "if" : {
#         "anyOf" : [
#           {
#             "field" : "type",
#             "equals" : "Microsoft.Storage/storageAccounts"
#           },
#           {
#             "field" : "type",
#             "equals" : "Microsoft.KeyVault/vaults"
#           },
#           {
#             "field" : "type",
#             "equals" : "Microsoft.Web/sites"
#           },
#           {
#             "field" : "type",
#             "equals" : "Microsoft.DBforMySQL/servers"
#           }
#         ]
#       }
#       "then" : {
#         "effect" : "[parameters('effect')]",
#         "details" : {
#           "type" : "Microsoft.Insights/diagnosticSettings",
#           "name" : "[parameters('profileName')]",
#           "existenceCondition" : {
#             "allOf" : [
#               {
#                 "field" : "Microsoft.Insights/diagnosticSettings/metrics.enabled",
#                 "equals" : "[parameters('metricsEnabled')]"
#               },
#               {
#                 "field" : "Microsoft.Insights/diagnosticSettings/workspaceId",
#                 "equals" : "[parameters('logAnalytics')]"
#               }
#             ]
#           },
#           "roleDefinitionIds" : [
#             "/providers/microsoft.authorization/roleDefinitions/749f88d5-cbae-40b8-bcfc-e573ddc772fa",
#             "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
#           ],
#           "deployment" : {
#             "properties" : {
#               "mode" : "incremental",
#               "template" : {
#                 "$schema" : "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
#                 "contentVersion" : "1.0.0.0",
#                 "parameters" : {
#                   "resourceName" : {
#                     "type" : "string"
#                   },
#                   "location" : {
#                     "type" : "string"
#                   },
#                   "logAnalytics" : {
#                     "type" : "string"
#                   },
#                   "metricsEnabled" : {
#                     "type" : "bool"
#                   },
#                   "profileName" : {
#                     "type" : "string"
#                   },
#                   "logsEnabled" : {
#                     "type" : "bool"
#                   }
#                 },
#                 "variables" : {},
#                 "resources" : [
#                   {
#                     "type" : "Microsoft.Storage/storageAccounts/providers/diagnosticSettings",
#                     "apiVersion" : "2021-05-01-preview",
#                     "name" : "[concat(parameters('resourceName'), '/', 'Microsoft.Insights/', parameters('profileName'))]",
#                     "condition" : "[equals(greater(length(resourceId('Microsoft.Storage/storageAccounts', parameters('resourceName'))), 0), true())]",
#                     "location" : "[parameters('location')]",
#                     "dependsOn" : [],
#                     "properties" : {
#                       "workspaceId" : "[parameters('logAnalytics')]",
#                       "metrics" : [
#                         {
#                           "category" : "AllMetrics",
#                           "enabled" : "[parameters('metricsEnabled')]"
#                         }
#                       ]
#                     }
#                   },
#                   {
#                     "type" : "Microsoft.KeyVault/vaults/providers/diagnosticSettings",
#                     "apiVersion" : "2017-05-01-preview",
#                     "name" : "[concat(parameters('resourceName'), '/', 'Microsoft.Insights/', parameters('profileName'))]",
#                     "condition" : "[equals(greater(length(resourceId('Microsoft.KeyVault/vaults', parameters('resourceName'))), 0), true())]",
#                     "location" : "[parameters('location')]",
#                     "dependsOn" : [],
#                     "properties" : {
#                       "workspaceId" : "[parameters('logAnalytics')]",
#                       "metrics" : [
#                         {
#                           "category" : "AllMetrics",
#                           "enabled" : "[parameters('metricsEnabled')]"
#                         }
#                       ],
#                       "logs" : [
#                         {
#                           "category" : "AuditEvent",
#                           "enabled" : "[parameters('logsEnabled')]"
#                         },
#                         {
#                           "category" : "AzurePolicyEvaluationDetails",
#                           "enabled" : "[parameters('logsEnabled')]"
#                         }
#                       ]
#                     }
#                   },
#                   {
#                     "type" : "Microsoft.Web/sites/providers/diagnosticSettings",
#                     "apiVersion" : "2017-05-01-preview",
#                     "name" : "[concat(parameters('resourceName'), '/', 'Microsoft.Insights/', parameters('profileName'))]",
#                     "condition" : "[equals(greater(length(resourceId('Microsoft.Web/sites', parameters('resourceName'))), 0), true())]",
#                     "location" : "[parameters('location')]",
#                     "dependsOn" : [],
#                     "properties" : {
#                       "workspaceId" : "[parameters('logAnalytics')]",
#                       "metrics" : [
#                         {
#                           "category" : "AllMetrics",
#                           "enabled" : "[parameters('metricsEnabled')]"
#                         }
#                       ]
#                     }
#                   },
#                   {
#                     "type" : "Microsoft.DBforMySQL/servers/providers/diagnosticSettings",
#                     "apiVersion" : "2017-05-01-preview",
#                     "name" : "[concat(parameters('resourceName'), '/', 'Microsoft.Insights/', parameters('profileName'))]",
#                     "condition" : "[equals(greater(length(resourceId('Microsoft.DBforMySQL/servers', parameters('resourceName'))), 0), true())]",
#                     "location" : "[parameters('location')]",
#                     "dependsOn" : [],
#                     "properties" : {
#                       "workspaceId" : "[parameters('logAnalytics')]",
#                       "metrics" : [
#                         {
#                           "category" : "AllMetrics",
#                           "enabled" : "[parameters('metricsEnabled')]"
#                         }
#                       ],
#                       "logs" : [
#                         {
#                           "category" : "MySqlSlowLogs",
#                           "enabled" : "[parameters('logsEnabled')]"
#                         },
#                         {
#                           "category" : "MySqlAuditLogs",
#                           "enabled" : "[parameters('logsEnabled')]"
#                         }
#                       ]
#                     }
#                   }
#                 ],
#                 "outputs" : {
#                   "resourceName" : {
#                     "type" : "string",
#                     "value" : "[parameters('resourceName')]"
#                   },
#                   "condition" : {
#                     "type" : "string",
#                     "value" : "[not(empty(resourceId('Microsoft.KeyVault/vaults', parameters('resourceName'))))]"
#                   },
#                   "resourceID" : {
#                     "type" : "string",
#                     "value" : "[resourceId('Microsoft.Storage/storageAccounts', parameters('resourceName'))]"
#                   }
#                 }
#               },
#               "parameters" : {
#                 "location" : {
#                   "value" : "[field('location')]"
#                 },
#                 "resourceName" : {
#                   "value" : "[field('fullName')]"
#                 },
#                 "logAnalytics" : {
#                   "value" : "[parameters('logAnalytics')]"
#                 },
#                 "metricsEnabled" : {
#                   "value" : "[parameters('metricsEnabled')]"
#                 },
#                 "profileName" : {
#                   "value" : "[parameters('profileName')]"
#                 },
#                 "logsEnabled" : {
#                   "value" : "[parameters('logsEnabled')]"
#                 }
#               }
#             }
#           }
#         }
#       }
#     }
#     create_assignment = true,
#     location          = "eastus"
#   },
#   {
#     name : "centralized-law"
#     display_name = "Centralized Log Analytics Workspace"
#     description  = "Deploy resource group containing Log Analytics workspace and to centralize logs and monitoring"
#     metadata = {
#       "version" : "1.0.0"
#       "category" : "Monitoring"
#     }
#     parameters = {
#       "environment" : {
#         "type" : "String",
#         "metadata" : {
#           "displayName" : "environment",
#           "description" : "Provide environment name"
#         },
#         "defaultValue" : "prod"
#       },
#       "workspaceName" : {
#         "type" : "String",
#         "metadata" : {
#           "displayName" : "workspaceName",
#           "description" : "Provide name for log analytics workspace"
#         },
#         "defaultValue" : "central-law"
#       },
#       "workspaceRegion" : {
#         "type" : "String",
#         "metadata" : {
#           "displayName" : "workspaceRegion",
#           "description" : "Enter Azure region for Log Analytics workspace",
#           "strongType" : "location"
#         },
#         "defaultValue" : "eastus"
#       },
#       "sku" : {
#         "type" : "String",
#         "metadata" : {
#           "displayName" : "sku",
#           "description" : "Select pricing tier. Legacy tiers (Free, Standalone, PerNode, Standard or Premium) are not available to all customers"
#         },
#         "allowedValues" : [
#           "pergb2018",
#           "Free",
#           "Standalone",
#           "PerNode",
#           "Standard",
#           "Premium"
#         ],
#         "defaultValue" : "pergb2018"
#       },
#       "dataRetention" : {
#         "type" : "String",
#         "metadata" : {
#           "displayName" : "dataRetention",
#           "description" : "Enter the retention period in workspace, can be between 7 to 730 days. Billing is per 30 days at the minimum even when retention is shorter"
#         },
#         "defaultValue" : "30"
#       },
#       "effect" : {
#         "type" : "String",
#         "metadata" : {
#           "displayName" : "Effect",
#           "description" : "Select DeployIfNotExists to deploy central Log Analytics workspace, Audit or Disable to disable the execution of the policy"
#         },
#         "allowedValues" : [
#           "DeployIfNotExists",
#           "AuditIfNotExists",
#           "Disabled"
#         ],
#         "defaultValue" : "DeployIfNotExists"
#       }
#     }
#     policy_rule = {
#       "if" : {
#         "field" : "type",
#         "equals" : "Microsoft.Resources/subscriptions"
#       },
#       "then" : {
#         "effect" : "[parameters('effect')]",
#         "details" : {
#           "type" : "Microsoft.OperationalInsights/workspaces",
#           "name" : "[concat(parameters('workspaceName'), '-', parameters('environment'))]",
#           "ResourceGroupName" : "[concat(parameters('workspaceName'), '-', parameters('environment'), '-rg')]",
#           "existenceScope" : "resourcegroup",
#           "deploymentScope" : "Subscription",
#           "roleDefinitionIds" : [
#             "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
#           ],
#           "deployment" : {
#             "location" : "East US",
#             "properties" : {
#               "mode" : "incremental",
#               "parameters" : {
#                 "workspaceName" : {
#                   "value" : "[parameters('workspaceName')]"
#                 },
#                 "workspaceRegion" : {
#                   "value" : "[parameters('workspaceRegion')]"
#                 },
#                 "dataRetention" : {
#                   "value" : "[parameters('dataRetention')]"
#                 },
#                 "sku" : {
#                   "value" : "[parameters('sku')]"
#                 },
#                 "environment" : {
#                   "value" : "[parameters('environment')]"
#                 }
#               },
#               "template" : {
#                 "$schema" : "http://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#",
#                 "contentVersion" : "1.0.0.0",
#                 "parameters" : {
#                   "workspaceName" : {
#                     "type" : "String"
#                   },
#                   "workspaceRegion" : {
#                     "type" : "String"
#                   },
#                   "dataRetention" : {
#                     "type" : "String"
#                   },
#                   "sku" : {
#                     "type" : "String"
#                   },
#                   "environment" : {
#                     "type" : "String"
#                   }
#                 },
#                 "variables" : {},
#                 "resources" : [
#                   {
#                     "type" : "Microsoft.Resources/resourceGroups",
#                     "apiVersion" : "2020-06-01",
#                     "name" : "[concat(parameters('workspaceName'), '-', parameters('environment'), '-rg')]",
#                     "location" : "[parameters('workspaceRegion')]",
#                     "properties" : {}
#                   },
#                   {
#                     "type" : "Microsoft.Resources/deployments",
#                     "apiVersion" : "2021-04-01",
#                     "name" : "[concat(parameters('workspaceName'), '-', parameters('environment'))]",
#                     "resourceGroup" : "[concat(parameters('workspaceName'), '-', parameters('environment'), '-rg')]",
#                     "dependsOn" : [
#                       "[resourceId('Microsoft.Resources/resourceGroups/', concat(parameters('workspaceName'), '-', parameters('environment'), '-rg'))]"
#                     ],
#                     "properties" : {
#                       "mode" : "Incremental",
#                       "template" : {
#                         "$schema" : "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json",
#                         "contentVersion" : "1.0.0.0",
#                         "parameters" : {},
#                         "variables" : {},
#                         "resources" : [
#                           {
#                             "apiVersion" : "2020-08-01",
#                             "location" : "[parameters('workspaceRegion')]",
#                             "name" : "[concat(parameters('workspaceName'), '-', parameters('environment'))]",
#                             "type" : "Microsoft.OperationalInsights/workspaces",
#                             "properties" : {
#                               "sku" : {
#                                 "name" : "[parameters('sku')]"
#                               },
#                               "retentionInDays" : "[parameters('dataRetention')]",
#                               "enableLogAccessUsingOnlyResourcePermissions" : true
#                             }
#                           }
#                         ],
#                         "outputs" : {}
#                       }
#                     }
#                   }
#                 ]
#               }
#             }
#           }
#         }
#       }
#     }
#     create_assignment = true,
#     location          = "eastus"
#   }
# ]

subscription_policy_rules = [
  {
    name              = "centralized-law"
    create_assignment = true
    file_name         = "ResourceGroupAndLogAnalyticsToCentralizeMonitoring"
    location          = "eastus"
  },
  {
    name              = "diagnostic-settings-centralized-law"
    create_assignment = true
    file_name         = "DiagnosticSettingsForAllResources"
    location          = "eastus"
  }
]