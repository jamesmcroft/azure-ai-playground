targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the workload which is used to generate a short unique hash used in all resources.')
param workloadName string

@minLength(1)
@description('Primary location for all resources.')
param location string

@description('Name of the resource group. If empty, a unique name will be generated.')
param resourceGroupName string = ''

@description('Tags for all resources.')
param tags object = {}

@description('Primary location for the Document Intelligence service. Default is westeurope for latest preview support.')
param documentIntelligenceLocation string = 'westeurope'

@description('Primary location for the completions OpenAI service. Default is francecentral for latest preview support.')
param completionsOpenAILocation string = 'francecentral'

@description('Primary location for the vision OpenAI service. Default is westus for latest preview support.')
param visionOpenAILocation string = 'westus'

var abbrs = loadJsonContent('./abbreviations.json')
var roles = loadJsonContent('./roles.json')
var resourceToken = toLower(uniqueString(subscription().id, workloadName, location))

var documentIntelligenceResourceToken = toLower(uniqueString(
  subscription().id,
  workloadName,
  documentIntelligenceLocation,
  'ai-document-intelligence'
))
var completionsResourceToken = toLower(uniqueString(
  subscription().id,
  workloadName,
  completionsOpenAILocation,
  'ai-completions'
))
var visionResourceToken = toLower(uniqueString(subscription().id, workloadName, visionOpenAILocation, 'ai-vision'))

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: !empty(resourceGroupName) ? resourceGroupName : '${abbrs.resourceGroup}${workloadName}'
  location: location
  tags: union(tags, {})
}

module managedIdentity './security/managed-identity.bicep' = {
  name: '${abbrs.managedIdentity}${resourceToken}'
  scope: resourceGroup
  params: {
    name: '${abbrs.managedIdentity}${resourceToken}'
    location: location
    tags: union(tags, {})
  }
}

resource cognitiveServicesUser 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  scope: resourceGroup
  name: roles.cognitiveServicesUser
}

module documentIntelligence './ai_ml/document-intelligence.bicep' = {
  name: '${abbrs.documentIntelligence}${documentIntelligenceResourceToken}'
  scope: resourceGroup
  params: {
    name: '${abbrs.documentIntelligence}${documentIntelligenceResourceToken}'
    location: documentIntelligenceLocation
    tags: union(tags, { Workload: workloadName, Capability: 'DocumentIntelligence' })
    roleAssignments: [
      {
        principalId: managedIdentity.outputs.principalId
        roleDefinitionId: cognitiveServicesUser.id
      }
    ]
  }
}

resource cognitiveServicesOpenAIUser 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  scope: resourceGroup
  name: roles.cognitiveServicesOpenAIUser
}

var completionsModelDeploymentName = 'gpt-35-turbo'
var visionModelDeploymentName = 'gpt-4-vision'
var embeddingModelDeploymentName = 'text-embedding-ada-002'

module completionsOpenAI './ai_ml/openai.bicep' = {
  name: '${abbrs.openAIService}${completionsResourceToken}'
  scope: resourceGroup
  params: {
    name: '${abbrs.openAIService}${completionsResourceToken}'
    location: completionsOpenAILocation
    tags: union(tags, { Workload: workloadName, Capability: 'Completions' })
    deployments: [
      {
        name: completionsModelDeploymentName
        model: {
          format: 'OpenAI'
          name: 'gpt-35-turbo'
          version: '1106'
        }
        sku: {
          name: 'Standard'
          capacity: 30
        }
      }
      {
        name: embeddingModelDeploymentName
        model: {
          format: 'OpenAI'
          name: 'text-embedding-ada-002'
          version: '2'
        }
        sku: {
          name: 'Standard'
          capacity: 30
        }
      }
    ]
    roleAssignments: [
      {
        principalId: managedIdentity.outputs.principalId
        roleDefinitionId: cognitiveServicesOpenAIUser.id
      }
    ]
  }
}

module visionOpenAI './ai_ml/openai.bicep' = {
  name: '${abbrs.openAIService}${visionResourceToken}'
  scope: resourceGroup
  params: {
    name: '${abbrs.openAIService}${visionResourceToken}'
    location: visionOpenAILocation
    tags: union(tags, { Workload: workloadName, Capability: 'Vision' })
    deployments: [
      {
        name: visionModelDeploymentName
        model: {
          format: 'OpenAI'
          name: 'gpt-4'
          version: 'vision-preview'
        }
        sku: {
          name: 'Standard'
          capacity: 30
        }
      }
      {
        name: embeddingModelDeploymentName
        model: {
          format: 'OpenAI'
          name: 'text-embedding-ada-002'
          version: '2'
        }
        sku: {
          name: 'Standard'
          capacity: 30
        }
      }
    ]
    roleAssignments: [
      {
        principalId: managedIdentity.outputs.principalId
        roleDefinitionId: cognitiveServicesOpenAIUser.id
      }
    ]
  }
}

output resourceGroupInfo object = {
  id: resourceGroup.id
  name: resourceGroup.name
  location: resourceGroup.location
  workloadName: workloadName
}

output managedIdentityInfo object = {
  id: managedIdentity.outputs.id
  name: managedIdentity.outputs.name
  principalId: managedIdentity.outputs.principalId
  clientId: managedIdentity.outputs.clientId
}

output documentIntelligenceInfo object = {
  id: documentIntelligence.outputs.id
  name: documentIntelligence.outputs.name
  endpoint: documentIntelligence.outputs.endpoint
  host: documentIntelligence.outputs.host
}

output completionsOpenAIInfo object = {
  id: completionsOpenAI.outputs.id
  name: completionsOpenAI.outputs.name
  endpoint: completionsOpenAI.outputs.endpoint
  host: completionsOpenAI.outputs.host
  completionModelDeploymentName: completionsModelDeploymentName
  embeddingModelDeploymentName: embeddingModelDeploymentName
}

output visionOpenAIInfo object = {
  id: visionOpenAI.outputs.id
  name: visionOpenAI.outputs.name
  endpoint: visionOpenAI.outputs.endpoint
  host: visionOpenAI.outputs.host
  visionModelDeploymentName: visionModelDeploymentName
  embeddingModelDeploymentName: embeddingModelDeploymentName
}
