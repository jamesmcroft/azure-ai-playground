param(
    [Parameter(Mandatory = $true)]
    [string]$DeploymentName,
    [Parameter(Mandatory = $true)]
    [string]$Location,
    [switch]$WhatIf,
    [switch]$Force
)

function Deploy-AzureInfrastructure($deploymentName, $location, $whatIf) {
    $principalId = (az ad signed-in-user show --query id -o tsv)
    $identity = @{ 
        "principalId"   = "$principalId"
        "principalType" = "User" 
    } 
    $identityArray = ConvertTo-Json @($identity) -Depth 5 -Compress
    $identityArray = $identityArray -replace '"', '\"'
     
    if ($whatIf) {
        Write-Host "Previewing Azure infrastructure deployment. No changes will be made."
    
        $result = (az deployment sub what-if `
                --name $deploymentName `
                --location $location `
                --template-file './main.bicep' `
                --parameters './main.bicepparam' `
                --parameters workloadName=$deploymentName `
                --parameters location=$location `
                --parameters identities=$identityArray `
                --no-pretty-print) | ConvertFrom-Json
    
        if (-not $result) {
            Write-Error "Azure infrastructure deployment preview failed."
            exit 1
        }
    
        Write-Host "Azure infrastructure deployment preview succeeded."
        $result.changes | Format-List
        exit
    }
    
    $deploymentOutputs = (az deployment sub create `
            --name $deploymentName `
            --location $location `
            --template-file './main.bicep' `
            --parameters './main.bicepparam' `
            --parameters workloadName=$deploymentName `
            --parameters location=$location `
            --parameters identities=$identityArray `
            --query properties.outputs -o json) | ConvertFrom-Json
    
    if (-not $deploymentOutputs) {
        Write-Error "Azure infrastructure deployment failed."
        exit 1
    }
    
    Write-Host "Azure infrastructure deployment succeeded."
    $deploymentOutputs | Format-List
    
    return $deploymentOutputs
}

Push-Location -Path $PSScriptRoot

$SubscriptionName = (az account show --query name -o tsv)

Write-Host "Starting deployment of an Azure AI Playground in subscription '$SubscriptionName'..."

$DeploymentOutputs = Deploy-AzureInfrastructure `
    -deploymentName $DeploymentName `
    -location $Location `
    -whatIf:$WhatIf

$DeploymentOutputs | ConvertTo-Json | Out-File -FilePath './InfrastructureOutputs.json' -Encoding utf8

Pop-Location

Write-Host "Deployment of an Azure AI Playground completed."

return $DeploymentOutputs