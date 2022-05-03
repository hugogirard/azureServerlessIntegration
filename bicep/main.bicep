targetScope='subscription'

@description('The location of all Azure Resources')
param location string

@secure()
param adminUsername string

@secure()
param adminPassword string

@secure()
param publisherEmail string

@secure()
param publisherName string

var integrateRgName = 'rg-integration-layer'
var premiseRgName = 'rg-premise-contoso'

var suffixIntegrationGuid = uniqueString(rgIntegration.id)
var suffixPremiseGuid = uniqueString(rgOnPremise.id)

resource rgIntegration 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: integrateRgName
  location: location
}

resource rgOnPremise 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: premiseRgName
  location: location
}

// ------- Begin Virtual Network -------

module vnetIntegration 'modules/networking/vnet.integration.bicep' = {
  scope: resourceGroup(rgIntegration.name)
  name: 'vnetIntegration'
  params: {
    location: location
  }
}

module vnetOnPremise 'modules/networking/vnet.onpremise.bicep' = {
  scope: resourceGroup(rgOnPremise.name)
  name: 'vnetOnPremise'
  params: {
    location: location
  }
}

module peeringIntegrationToPremise 'modules/networking/peering.bicep' = {
  scope: resourceGroup(rgIntegration.name)
  name: 'peeringIntegrationToPremise'
  params: {
    peeringName: '${vnetIntegration.outputs.name}/integration-to-premise'    
    remoteVnetId: vnetOnPremise.outputs.id
  }
}

module peeringPremiseToIntegration 'modules/networking/peering.bicep' = {
  scope: resourceGroup(rgOnPremise.name)
  name: 'peeringPremiseToIntegration'
  params: {
    peeringName: '${vnetOnPremise.outputs.name}/premise-to-integration'    
    remoteVnetId: vnetIntegration.outputs.id
  }
}

module legacyServer 'modules/compute/legacy.bicep' = {
  scope: resourceGroup(rgOnPremise.name)
  name: 'legacyserver'
  params: {
    adminPassword: adminPassword
    adminUsername: adminUsername
    location: location
    subnetId: vnetOnPremise.outputs.subnetId
    suffix: suffixPremiseGuid
  }
}

module dataFactory 'modules/dataFactory/factory.bicep' = {
  scope: resourceGroup(rgIntegration.name)
  name: 'dataFactory'
  params: {
    location: location
    suffix: suffixIntegrationGuid
  }
}

module pipeline 'modules/dataFactory/pipeline/copyToBlob.bicep' = {
  scope: resourceGroup(rgIntegration.name)
  name: 'pipeline'
  params: {
    azureFactoryName: dataFactory.outputs.dataFactoryName
    storageDestinationName: storage.outputs.strCopyDestination
    storageSourceName: storage.outputs.strFileName
  }
}

module monitoring 'modules/monitoring/insight.bicep' = {
  scope: resourceGroup(rgIntegration.name)
  name: 'monitoring'
  params: {
    location: location
    suffix: suffixIntegrationGuid
  }
}

module storage 'modules/storage/storage.bicep' = {
  scope: resourceGroup(rgIntegration.name)
  name: 'storage'
  params: {
    location: location
  }
}

module logicApp 'modules/logicapp/logic.bicep' = {
  scope: resourceGroup(rgIntegration.name)
  name: 'logicapp'
  params: {
    insightName: monitoring.outputs.insightName
    location: location
    storageName: storage.outputs.strLogicName
    suffix: suffixIntegrationGuid
    cosmosDBName: cosmos.outputs.cosmosDBName
    sbRules: bus.outputs.sbRules
  }
}

module cosmos 'modules/cosmos/db.bicep' = {
  scope: resourceGroup(rgIntegration.name)
  name: 'cosmos'
  params: {
    location: location
    suffix: suffixIntegrationGuid
  }
}

module bus 'modules/bus/servicebus.bicep' = {
  scope: resourceGroup(rgIntegration.name)
  name: 'bus'
  params: {
    location: location
    suffix: suffixIntegrationGuid
  }
}

module apim 'modules/apim/apim.bicep' = {
  scope: resourceGroup(rgIntegration.name)
  name: 'apim'
  params: {
    location: location 
    publisherEmail: publisherEmail
    publisherName: publisherName
    subnetId: vnetIntegration.outputs.apimSubnetId
    suffix: suffixIntegrationGuid
  }
}

output logicAppName string = logicApp.outputs.logicAppName
