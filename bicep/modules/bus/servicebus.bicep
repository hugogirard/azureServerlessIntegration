param location string
param suffix string

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2021-11-01' = {
  name: 'sb-${suffix}'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {}
}

resource serviceBusQueue 'Microsoft.ServiceBus/namespaces/queues@2017-04-01' = {
  name: '${serviceBusNamespace.name}/order'
  properties: {
  }
}

resource rules 'Microsoft.ServiceBus/namespaces/AuthorizationRules@2021-11-01' = {
  name: 'sendListenAccess'
  parent: serviceBusNamespace
  properties: {
    rights: [
      'Listen'
      'Send'
    ]
  }
}

output sbRules string = rules.name
