using './routeTable.bicep'

param routeTableName = 'RT01'
param routeTableLocation = 'eastus2'
param routeTableDisableBgpRoutePropagation = false
param routes = [
  {
    name: 'default'
    properties: {
      addressPrefix: '0.0.0.0/0'
      nextHopType: 'VirtualAppliance'
      nextHopIpAddress: '192.168.0.1'
    }
  }
  {
    name: 'AZKMS'
    properties: {
      addressPrefix: '52.126.105.2/32'
      nextHopType: 'Internet'
    }
  }
]

