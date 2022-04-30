param location string

var vnetName = 'vnet-hub'
var addressPrefix = '12.0.0.0/16'
var snetFtpAddressPrefix = '12.0.1.0/27'

resource nsgWebserver 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'nsg-webserver'
  location: location
  properties: {
    securityRules: [      
    ]
  }
}

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
        name: 'snet-webserver'
        properties: {
          addressPrefix: snetFtpAddressPrefix
          networkSecurityGroup: {
            id: nsgWebserver.id
          }
        }
      }
    ]
  }
}

output subnetId string = vnet.properties.subnets[0].id
