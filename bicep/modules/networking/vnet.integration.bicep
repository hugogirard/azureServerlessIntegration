param location string

var vnetName = 'vnet-integration'
var addressPrefix = '11.0.0.0/16'
var snetAddressPrefix = '11.0.1.0/24'

resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: 'snet-apim'
        properties: {
          addressPrefix: snetAddressPrefix
        }
      }
    ]
  }
}

output name string = vnet.name
output id string = vnet.id
output apimSubnetId string = vnet.properties.subnets[0].id
