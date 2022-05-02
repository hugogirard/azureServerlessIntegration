param storageFileName string
param azureFactoryName string

var linkedServiceSourceName = 'AzureStorageSourceLinkedService'
var dataSetSource = 'AzureStorageBlobSourceDataset'

resource storageFile 'Microsoft.Storage/storageAccounts@2021-04-01' existing = {
  name: storageFileName
}

var strCnxString = 'DefaultEndpointsProtocol=https;AccountName=${storageFile.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageFile.id, storageFile.apiVersion).keys[0].value}'

resource linkedServiceSource 'Microsoft.DataFactory/factories/linkedservices@2018-06-01' = {
  name: '${azureFactoryName}/${linkedServiceSourceName}'
  properties: {
    annotations: []
    type: 'AzureBlobStorage'
    typeProperties: {
      connectionString: strCnxString
    }
  }
}

resource datasetSource 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: '${azureFactoryName}/${dataSetSource}'
  dependsOn: [
    linkedServiceSource
  ]
  properties: {
    linkedServiceName: {
      referenceName: linkedServiceSourceName
      type: 'LinkedServiceReference'
    }
    parameters: {
      filename: {
        type: 'String'
      }
    }
    annotations: []    
    type: 'Binary'
    typeProperties: {
      location: {
        type: 'AzureBlobStorageLocation'
        fileName: {
          value: '@dataset().filename'
          type: 'Expression'
        }
        container: 'documents'
      }
    }
  }
}
