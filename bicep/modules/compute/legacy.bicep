param location string

param suffix string

param subnetId string

@secure()
param adminUsername string

@secure()
param adminPassword string

var vmName = 'legacyvm'

var dataDiskResources = {
  values: [
    {
      name: 'legacySystem_DataDisk_0'
      sku: 'Premium_LRS'
      properties: {
          diskSizeGB: 1024
          creationData: {
              createOption: 'empty'
          }
      }      
    }
    {
      name: 'legacySystem_DataDisk_1'
      sku: 'Premium_LRS'
      properties: {
          diskSizeGB: 1024
          creationData: {
              createOption: 'empty'
          }
      }      
    }    
  ]
}

resource pip 'Microsoft.Network/publicIPAddresses@2021-05-01' = {
  name: 'pip-legacy-${suffix}'
  location: location
  properties: {
    publicIPAllocationMethod: 'Static'
  }
  sku: {
    name: 'Standard'
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: 'nic-legacy-${suffix}'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig'
        properties: {
          subnet: {
            id: subnetId
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: pip.id
            properties: {
              deleteOption: 'Delete'
            }
          }          
        }
      }
    ]
  }
}




resource legacyVm 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B4ms'
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
        deleteOption: 'Delete'
      }
      imageReference: {
        publisher: 'microsoftsqlserver'
        offer: 'sql2019-ws2022'
        sku: 'sqldev'
        version: 'latest'
      }
    }  
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
          properties: {
            deleteOption: 'Delete'
          }
        }
      ]
    }  
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        enableAutomaticUpdates: true
        provisionVMAgent: true
        patchSettings: {
          enableHotpatching: true
          patchMode: 'AutomaticByOS'
        }
      }
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

resource sql 'Microsoft.SqlVirtualMachine/sqlVirtualMachines@2021-11-01-preview' = {
  name: 'nic-legacy-${suffix}'
  location: location
  properties: {
    virtualMachineResourceId: legacyVm.id
    sqlManagement: 'Full'
    autoPatchingSettings: {
      enable: true
      dayOfWeek: 'Sunday'
      maintenanceWindowStartingHour: 2
      maintenanceWindowDuration: 60
    }
    serverConfigurationsManagementSettings: {
      sqlConnectivityUpdateSettings: {
        connectivityType: 'PRIVATE'
        port: 1433
        sqlAuthUpdateUserName: adminUsername
        sqlAuthUpdatePassword: adminPassword
      }
    }
  }
}