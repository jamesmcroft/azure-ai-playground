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

@description('Primary location for the completions OpenAI service. Default is swedencentral for most complete model support.')
param openAILocation string = 'swedencentral'

@description('Principal ID of the user that will be granted permission to access services.')
param userPrincipalId string

var abbrs = loadJsonContent('./abbreviations.json')
var roles = loadJsonContent('./roles.json')
var resourceToken = toLower(uniqueString(subscription().id, workloadName, location))
var documentIntelligenceResourceToken = toLower(uniqueString(
  subscription().id,
  workloadName,
  documentIntelligenceLocation,
  'ai-document-intelligence'
))
var openAIResourceToken = toLower(uniqueString(subscription().id, workloadName, openAILocation, 'openai'))

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: !empty(resourceGroupName) ? resourceGroupName : '${abbrs.managementGovernance.resourceGroup}${workloadName}'
  location: location
  tags: union(tags, {})
}

module managedIdentity './security/managed-identity.bicep' = {
  name: '${abbrs.security.managedIdentity}${resourceToken}'
  scope: resourceGroup
  params: {
    name: '${abbrs.security.managedIdentity}${resourceToken}'
    location: location
    tags: union(tags, {})
  }
}

resource contributor 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  scope: resourceGroup
  name: roles.general.contributor
}

module resouceGroupRoleAssignment './security/resource-group-role-assignment.bicep' = {
  name: '${resourceGroup.name}-role-assignment'
  scope: resourceGroup
  params: {
    roleAssignments: [
      {
        principalId: userPrincipalId
        roleDefinitionId: contributor.id
        principalType: 'User'
      }
      {
        principalId: managedIdentity.outputs.principalId
        roleDefinitionId: contributor.id
        principalType: 'ServicePrincipal'
      }
    ]
  }
}

resource cognitiveServicesUser 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  scope: resourceGroup
  name: roles.ai.cognitiveServicesUser
}

module documentIntelligenceService './ai_ml/document-intelligence.bicep' = {
  name: '${abbrs.ai.documentIntelligence}${documentIntelligenceResourceToken}'
  scope: resourceGroup
  params: {
    name: '${abbrs.ai.documentIntelligence}${documentIntelligenceResourceToken}'
    location: documentIntelligenceLocation
    tags: union(tags, { Workload: workloadName, Capability: 'DocumentIntelligence' })
    disableLocalAuth: true
    roleAssignments: [
      {
        principalId: userPrincipalId
        roleDefinitionId: cognitiveServicesUser.id
        principalType: 'User'
      }
      {
        principalId: managedIdentity.outputs.principalId
        roleDefinitionId: cognitiveServicesUser.id
        principalType: 'ServicePrincipal'
      }
    ]
  }
}

resource storageBlobDataContributor 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  scope: resourceGroup
  name: roles.storage.storageBlobDataContributor
}

module storageAccount './storage/storage-account.bicep' = {
  name: '${abbrs.storage.storageAccount}${resourceToken}'
  scope: resourceGroup
  params: {
    name: '${abbrs.storage.storageAccount}${resourceToken}'
    location: location
    tags: union(tags, {})
    sku: {
      name: 'Standard_LRS'
    }
    roleAssignments: [
      {
        principalId: userPrincipalId
        roleDefinitionId: storageBlobDataContributor.id
        principalType: 'User'
      }
      {
        principalId: managedIdentity.outputs.principalId
        roleDefinitionId: storageBlobDataContributor.id
        principalType: 'ServicePrincipal'
      }
      {
        principalId: documentIntelligenceService.outputs.systemIdentityPrincipalId
        roleDefinitionId: storageBlobDataContributor.id
        principalType: 'ServicePrincipal'
      }
    ]
  }
}

resource cognitiveServicesOpenAIContributor 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  scope: resourceGroup
  name: roles.ai.cognitiveServicesOpenAIContributor
}

var completionsModelDeploymentName = 'gpt-4o'
var embeddingModelDeploymentName = 'text-embedding-ada-002'

module openAIService './ai_ml/openai.bicep' = {
  name: '${abbrs.ai.openAIService}${openAIResourceToken}'
  scope: resourceGroup
  params: {
    name: '${abbrs.ai.openAIService}${openAIResourceToken}'
    location: openAILocation
    tags: union(tags, { Workload: workloadName, Capability: 'Generative AI' })
    disableLocalAuth: true
    deployments: [
      {
        name: completionsModelDeploymentName
        model: {
          format: 'OpenAI'
          name: 'gpt-4o'
          version: '2024-05-13'
        }
        sku: {
          name: 'Standard'
          capacity: 10
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
          capacity: 10
        }
      }
    ]
    roleAssignments: [
      {
        principalId: userPrincipalId
        roleDefinitionId: cognitiveServicesOpenAIContributor.id
        principalType: 'User'
      }
      {
        principalId: managedIdentity.outputs.principalId
        roleDefinitionId: cognitiveServicesOpenAIContributor.id
        principalType: 'ServicePrincipal'
      }
    ]
  }
}

output subscriptionInfo object = {
  id: subscription().subscriptionId
  tenantId: subscription().tenantId
}

output resourceGroupInfo object = {
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

output storageAccountInfo object = {
  id: storageAccount.outputs.id
  name: storageAccount.outputs.name
}

output documentIntelligenceInfo object = {
  id: documentIntelligenceService.outputs.id
  name: documentIntelligenceService.outputs.name
  endpoint: documentIntelligenceService.outputs.endpoint
  host: documentIntelligenceService.outputs.host
  identityPrincipalId: documentIntelligenceService.outputs.systemIdentityPrincipalId
}

output openAIInfo object = {
  id: openAIService.outputs.id
  name: openAIService.outputs.name
  endpoint: openAIService.outputs.endpoint
  host: openAIService.outputs.host
  completionModelDeploymentName: completionsModelDeploymentName
  embeddingModelDeploymentName: embeddingModelDeploymentName
}
