<#
.SYNOPSIS
    Deploys the infrastructure and applications required to run the solution.
.PARAMETER DeploymentName
	The name of the deployment.
.PARAMETER Location
    The location of the deployment.
.PARAMETER SkipInfrastructure
    Whether to skip the infrastructure deployment. Requires InfrastructureOutputs.json to exist in the infra directory.
.EXAMPLE
    .\Setup-Environment.ps1 -DeploymentName 'my-deployment' -Location 'westeurope' -SkipInfrastructure $false
.NOTES
    Author: James Croft
    Date: 2024-04-22
#>

param
(
    [Parameter(Mandatory = $true)]
    [string]$DeploymentName,
    [Parameter(Mandatory = $true)]
    [string]$Location,
    [Parameter(Mandatory = $true)]
    [string]$SkipInfrastructure
)

function Set-ConfigurationFileVariable($configurationFile, $variableName, $variableValue) {
    if (-not (Test-Path $configurationFile)) {
        New-Item -Path $configurationFile -ItemType file
    }

    if (Select-String -Path $configurationFile -Pattern $variableName) {
        (Get-Content $configurationFile) | Foreach-Object {
            $_ -replace "$variableName = .*", "$variableName = $variableValue"
        } | Set-Content $configurationFile
    }
    else {
        Add-Content -Path $configurationFile -value "$variableName = $variableValue"
    }
}

Write-Host "Starting environment setup..."

if ($SkipInfrastructure -eq '$false' -or -not (Test-Path -Path './infra/InfrastructureOutputs.json')) {
    Write-Host "Deploying infrastructure..."
    $InfrastructureOutputs = (./infra/Deploy-Infrastructure.ps1 `
            -DeploymentName $DeploymentName `
            -Location $Location)
}
else {
    Write-Host "Skipping infrastructure deployment. Using existing outputs..."
    $InfrastructureOutputs = Get-Content -Path './infra/InfrastructureOutputs.json' -Raw | ConvertFrom-Json
}

$ResourceGroupName = $InfrastructureOutputs.resourceGroupInfo.value.name
$ManagedIdentityClientId = $InfrastructureOutputs.managedIdentityInfo.value.clientId
$StorageAccountName = $InfrastructureOutputs.storageAccountInfo.value.name
$DocumentIntelligenceEndpoint = $InfrastructureOutputs.documentIntelligenceInfo.value.endpoint
$CompletionsOpenAIEndpoint = $InfrastructureOutputs.openAIInfo.value.endpoint
$CompletionsOpenAIEmbeddingDeployment = $InfrastructureOutputs.openAIInfo.value.embeddingModelDeploymentName
$CompletionsOpenAIModelDeployment = $InfrastructureOutputs.openAIInfo.value.completionModelDeploymentName

Write-Host "Updating local settings..."

$ConfigurationFile = './.env'

Set-ConfigurationFileVariable -configurationFile $ConfigurationFile -variableName 'RESOURCE_GROUP_NAME' -variableValue $ResourceGroupName
Set-ConfigurationFileVariable -configurationFile $ConfigurationFile -variableName 'MANAGED_IDENTITY_CLIENT_ID' -variableValue $ManagedIdentityClientId
Set-ConfigurationFileVariable -configurationFile $ConfigurationFile -variableName 'STORAGE_ACCOUNT_NAME' -variableValue $StorageAccountName
Set-ConfigurationFileVariable -configurationFile $ConfigurationFile -variableName 'DOCUMENT_INTELLIGENCE_ENDPOINT' -variableValue $DocumentIntelligenceEndpoint
Set-ConfigurationFileVariable -configurationFile $ConfigurationFile -variableName 'COMPLETIONS_OPENAI_ENDPOINT' -variableValue $CompletionsOpenAIEndpoint
Set-ConfigurationFileVariable -configurationFile $ConfigurationFile -variableName 'COMPLETIONS_OPENAI_EMBEDDING_MODEL_DEPLOYMENT' -variableValue $CompletionsOpenAIEmbeddingDeployment
Set-ConfigurationFileVariable -configurationFile $ConfigurationFile -variableName 'COMPLETIONS_OPENAI_COMPLETION_MODEL_DEPLOYMENT' -variableValue $CompletionsOpenAIModelDeployment
