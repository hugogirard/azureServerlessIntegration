param location string
param suffix string

var cosmosName = 'cosmos-${suffix}'
var databaseName = 'contoso'

resource cosmos 'Microsoft.DocumentDB/databaseAccounts@2021-11-15-preview' = {
  name: cosmosName
  kind: 'GlobalDocumentDB'
  location: location
  properties: {
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        failoverPriority: 0
        locationName: location
      }
    ]
    capabilities: [
      {
        name: 'EnableServerless'
      }
    ]
  }
}

resource database 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2021-04-15' = {
  name: databaseName
  parent: cosmos
  properties: {
    resource: {
      id: databaseName
    }
  }
}

resource customerContainer 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2016-03-31' = {
  name: 'customer'
  parent: database
  properties: {
    options: {
    }
    resource: {
      id: 'customer'
      partitionKey: {
        paths: [
          '/id'
        ]
        kind: 'Hash'
      }
    }
  }
}

resource orderContainer 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2016-03-31' = {
  name: 'order'
  parent: database
  properties: {
    options: {
    }
    resource: {
      id: 'order'
      partitionKey: {
        paths: [
          '/orderId'
        ]
        kind: 'Hash'
      }
    }
  }
}

output cosmosDBName string = cosmos.name
