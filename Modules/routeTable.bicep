targetScope = 'resourceGroup'

param routeTableName string = 'RT-Spoke-01-subnet1'
param routeTableLocation string = resourceGroup().location
param routeTableDisableBgpRoutePropagation bool = true
param routes array = []
param routeTableTags object = resourceGroup().tags

resource routeTable 'Microsoft.Network/routeTables@2024-01-01' = {
  name: routeTableName
  location: routeTableLocation
  tags: routeTableTags
  properties: {
    disableBgpRoutePropagation: routeTableDisableBgpRoutePropagation
    routes: routes
  }
}
