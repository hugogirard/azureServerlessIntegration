param location string

var vnetName = 'vnet-hub'
var addressPrefix = '12.0.0.0/16'
var snetFtpAddressPrefix = '12.0.1.0/27'

resource nsgTfp 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'nsg-ftp'
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
        name: 'snet-ftp'
        properties: {
          addressPrefix: snetFtpAddressPrefix
          networkSecurityGroup: {
            id: nsgTfp.id
          }
        }
      }
    ]
  }
}
