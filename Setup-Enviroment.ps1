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

if ($SkipInfrastructure -eq '$false' || -not (Test-Path -Path './infra/InfrastructureOutputs.json')) {
    Write-Host "Deploying infrastructure..."
    $InfrastructureOutputs = (./infra/Deploy-Infrastructure.ps1 `
            -DeploymentName $DeploymentName `
            -Location $Location `
            -ErrorAction Stop)
}
else {
    Write-Host "Skipping infrastructure deployment. Using existing outputs..."
    $InfrastructureOutputs = Get-Content -Path './infra/InfrastructureOutputs.json' -Raw | ConvertFrom-Json
}

$ResourceGroupName = $InfrastructureOutputs.resourceGroupInfo.value.name
$DocumentIntelligenceEndpoint = $InfrastructureOutputs.documentIntelligenceInfo.value.endpoint
$CompletionsOpenAIEndpoint = $InfrastructureOutputs.completionsOpenAIInfo.value.endpoint
$CompletionsOpenAIEmbeddingDeployment = $InfrastructureOutputs.completionsOpenAIInfo.value.embeddingModelDeploymentName
$CompletionsOpenAIModelDeployment = $InfrastructureOutputs.completionsOpenAIInfo.value.completionModelDeploymentName
$VisionOpenAIEndpoint = $InfrastructureOutputs.visionOpenAIInfo.value.endpoint
$VisionOpenAIEmbeddingDeployment = $InfrastructureOutputs.visionOpenAIInfo.value.embeddingModelDeploymentName
$VisionOpenAIModelDeployment = $InfrastructureOutputs.visionOpenAIInfo.value.visionModelDeploymentName

Write-Host "Updating local settings..."

$ConfigurationFile = './.env'

Set-ConfigurationFileVariable -configurationFile $ConfigurationFile -variableName 'RESOURCE_GROUP_NAME' -variableValue $ResourceGroupName
Set-ConfigurationFileVariable -configurationFile $ConfigurationFile -variableName 'DOCUMENT_INTELLIGENCE_ENDPOINT' -variableValue $DocumentIntelligenceEndpoint
Set-ConfigurationFileVariable -configurationFile $ConfigurationFile -variableName 'COMPLETIONS_OPENAI_ENDPOINT' -variableValue $CompletionsOpenAIEndpoint
Set-ConfigurationFileVariable -configurationFile $ConfigurationFile -variableName 'COMPLETIONS_OPENAI_EMBEDDING_MODEL_DEPLOYMENT' -variableValue $CompletionsOpenAIEmbeddingDeployment
Set-ConfigurationFileVariable -configurationFile $ConfigurationFile -variableName 'COMPLETIONS_OPENAI_COMPLETION_MODEL_DEPLOYMENT' -variableValue $CompletionsOpenAIModelDeployment
Set-ConfigurationFileVariable -configurationFile $ConfigurationFile -variableName 'VISION_OPENAI_ENDPOINT' -variableValue $VisionOpenAIEndpoint
Set-ConfigurationFileVariable -configurationFile $ConfigurationFile -variableName 'VISION_OPENAI_EMBEDDING_MODEL_DEPLOYMENT' -variableValue $VisionOpenAIEmbeddingDeployment
Set-ConfigurationFileVariable -configurationFile $ConfigurationFile -variableName 'VISION_OPENAI_MODEL_DEPLOYMENT' -variableValue $VisionOpenAIModelDeployment