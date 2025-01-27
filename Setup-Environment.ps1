param
(
    [Parameter(Mandatory = $true)]
    [string]$DeploymentName,
    [Parameter(Mandatory = $true)]
    [string]$Location,
    [switch]$WhatIf,
    [switch]$Force
)

function Set-ConfigurationFileVariable($configurationFile, $variableName, $variableValue) {
    if (-not (Test-Path $configurationFile)) {
        New-Item -Path $configurationFile -ItemType file
    }

    if (Select-String -Path $configurationFile -Pattern $variableName) {
        (Get-Content $configurationFile) | Foreach-Object {
            $_ -replace "$variableName=.*", "$variableName=$variableValue"
        } | Set-Content $configurationFile
    }
    else {
        Add-Content -Path $configurationFile -value "$variableName=$variableValue"
    }
}

Write-Host "Starting environment setup..."

Write-Host "Deploying infrastructure..."
$InfrastructureOutputs = (./infra/Deploy-Infrastructure.ps1 `
        -DeploymentName $DeploymentName `
        -Location $Location `
        -WhatIf:$WhatIf `
        -Force:$Force)

$ResourceGroupName = $InfrastructureOutputs.resourceGroupInfo.value.name
$ManagedIdentityClientId = $InfrastructureOutputs.managedIdentityInfo.value.clientId
$StorageAccountName = $InfrastructureOutputs.storageAccountInfo.value.name
$DocumentIntelligenceEndpoint = $InfrastructureOutputs.aiServicesInfo.value.endpoint
$CompletionsOpenAIEndpoint = $InfrastructureOutputs.aiServicesInfo.value.openAIEndpoint
$CompletionsOpenAIEmbeddingDeployment = $InfrastructureOutputs.aiServicesInfo.value.embeddingModelDeploymentName
$CompletionsOpenAIModelDeployment = $InfrastructureOutputs.aiServicesInfo.value.completionModelDeploymentName

Write-Host "Updating local settings..."

$ConfigurationFile = './.env'

Set-ConfigurationFileVariable -configurationFile $ConfigurationFile -variableName 'RESOURCE_GROUP_NAME' -variableValue $ResourceGroupName
Set-ConfigurationFileVariable -configurationFile $ConfigurationFile -variableName 'MANAGED_IDENTITY_CLIENT_ID' -variableValue $ManagedIdentityClientId
Set-ConfigurationFileVariable -configurationFile $ConfigurationFile -variableName 'STORAGE_ACCOUNT_NAME' -variableValue $StorageAccountName
Set-ConfigurationFileVariable -configurationFile $ConfigurationFile -variableName 'DOCUMENT_INTELLIGENCE_ENDPOINT' -variableValue $DocumentIntelligenceEndpoint
Set-ConfigurationFileVariable -configurationFile $ConfigurationFile -variableName 'COMPLETIONS_OPENAI_ENDPOINT' -variableValue $CompletionsOpenAIEndpoint
Set-ConfigurationFileVariable -configurationFile $ConfigurationFile -variableName 'COMPLETIONS_OPENAI_EMBEDDING_MODEL_DEPLOYMENT' -variableValue $CompletionsOpenAIEmbeddingDeployment
Set-ConfigurationFileVariable -configurationFile $ConfigurationFile -variableName 'COMPLETIONS_OPENAI_COMPLETION_MODEL_DEPLOYMENT' -variableValue $CompletionsOpenAIModelDeployment
