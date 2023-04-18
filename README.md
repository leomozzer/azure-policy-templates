# azure-policy-templates
Collection of Azure Policy that can be used as template

## Templates
- diagnostic settings for all resources
    - Enable the Diagnostic Settings in all the listed resources:
        - Key Vaults
        - Storage Accounts
        - Web Apps
        - MySql
    - Required fields:
        - Log Analytics workspace
    - Default values:
        - effect: "DeployIfNotExists"
        - profileName: "AzPolicyDiagnosticSetting"
        - metricsEnabled: true
        - logsEnabled: true
    - Result: Every resource listed will have the `AzPolicyDiagnosticSetting` enabled in the Diagnostic Settings blade 