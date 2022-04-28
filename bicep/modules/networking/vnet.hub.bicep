param location string

var vnetName = 'vnet-hub'
var addressPrefix = '10.0.0.0/16'
var subnetRunnerPrefix = '10.0.1.0/27'
var subnetJumpboxPrefix = '10.0.2.0/27'

resource nsgrunner 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'nsg-runner'
  location: location
  properties: {
    securityRules: [      
    ]
  }
}

resource nsgJumpbox 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'nsg-jumpbox'
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
        name: 'snet-runner'
        properties: {
          addressPrefix: subnetRunnerPrefix
          networkSecurityGroup: {
            id: nsgrunner.id
          }
        }
      }
      {
        name: 'snet-jumpbox'
        properties: {
          addressPrefix: subnetJumpboxPrefix
          networkSecurityGroup: {
            id: nsgJumpbox.id
          }
        }
      }      
    ]
  }
}


output runnerSubnetId string = vnet.properties.subnets[0].id
