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

## Docs

- [GitHub Action](https://github.com/leomozzer/devops-project-1/blob/main/.github/actions/azure-setup/action.yaml)
