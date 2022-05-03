param location string

var strLogicApp = 'strl${uniqueString(resourceGroup().id)}'
var strFile = 'strf${uniqueString(resourceGroup().id)}'
var strDestination = 'strd${uniqueString(resourceGroup().id)}'

resource storageAccountApp 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: strLogicApp
  location: location
  sku: {
    name: 'Standard_LRS'    
  }
  tags: {
    'description': 'LogicApp Storage'
  }
  kind: 'StorageV2'
  properties: {    
    accessTier: 'Hot'
  }
}

resource storageUploadLargeFile 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: strFile
  location: location
  sku: {
    name: 'Standard_LRS'    
  }
  tags: {
    'description': 'File Transfer Storage Upload'
  }
  kind: 'StorageV2'
  properties: {    
    accessTier: 'Hot'
  }
}

resource storageCopyDestination 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: strDestination
  location: location
  sku: {
    name: 'Standard_LRS'    
  }
  tags: {
    'description': 'File Transfer Storage Destination'
  }
  kind: 'StorageV2'
  properties: {    
    accessTier: 'Hot'
  }  
}

resource containerDocumentUpload 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-04-01' = {  
  name: '${storageUploadLargeFile.name}/default/documents'
  properties: {
    publicAccess: 'None'
  }
}

output strLogicName string = storageAccountApp.name
output strFileName string = storageUploadLargeFile.name
output strCopyDestination string = storageCopyDestination.name


