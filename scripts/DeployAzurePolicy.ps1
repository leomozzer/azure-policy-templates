#require Az.PolicyInsights and Az.Resources
try{
    $SubscriptionId = (Get-AzContext).Subscription.Id
    $WorkingDir = Join-Path $PSScriptRoot ".." "policy"
    Write-Output $WorkingDir
    $PolicyList = Get-ChildItem $WorkingDir
    foreach($policyFile in $PolicyList){
        $AzPolicyAssignmentDeploy = $false
        $policyName = $policyFile.Name.replace(".json", "")
        $AzPolicyDefinitionFileContent = Get-Content "$($WorkingDir)\$($policyFile.Name)" | Out-String | ConvertFrom-Json
        $AzPolicyDefinitionName = $AzPolicyDefinitionFileContent.properties.displayName
        Write-Output "Getting Policy Definition '$($policyName)'"
        $GetPolicy = Get-AzPolicyDefinition -name $policyName
        if(!$GetPolicy){
            Write-Output "Policy Definition '$($policyName)' doesn't exists. Creating a new Definition"
            $GetPolicy = New-AzPolicyDefinition -Name $policyName -Policy "$($WorkingDir)\$($policyFile.Name)"
        }
        start-sleep 10
        Write-Output "Getting Policy Assignment '$($policyName)'"
        $GetPolicyAssignment = Get-AzPolicyAssignment -name $policyName -scope "/subscriptions/$($SubscriptionId)"
        if(!$GetPolicyAssignment){
            Write-Output "Policy Assignment '$($policyName)' wasn't found. Creating a new Assignment"
            $NewAzPolicyAssignment = New-AzPolicyAssignment -Name $policyName -PolicyDefinition $GetPolicy -scope "/subscriptions/$($SubscriptionId)" -IdentityType 'SystemAssigned' -Location "eastus"
            Write-Output "Starting remediation for '$($policyName)'"
            Start-AzPolicyRemediation -PolicyAssignmentId $NewAzPolicyAssignment.PolicyAssignmentId -Name "remediation"
        }
    }
}
catch{
    Write-Warning $Error[0]
}