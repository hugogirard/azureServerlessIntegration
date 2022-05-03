param location string
param suffix string
param subnetId string

@secure()
param publisherEmail string

@secure()
param publisherName string

resource apim 'Microsoft.ApiManagement/service@2021-08-01' = {
  name: 'api-${suffix}'
  location: location
  sku: {
    capacity: 1
    name: 'Developer'
  }
  properties: {
    publisherEmail: publisherEmail
    publisherName: publisherName
    virtualNetworkType: 'External'
    virtualNetworkConfiguration: {
      subnetResourceId: subnetId
    }    
  }
}

