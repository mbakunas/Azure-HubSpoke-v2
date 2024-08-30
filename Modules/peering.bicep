targetScope = 'resourceGroup'

param vnet1Name string
param vnet2ID string
param vnet2Name string
param vnet1isHub bool = false
param vnet2isHub bool = false

resource peering2 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-01-01' = {
  name: '${vnet1Name}/${vnet1Name}_to_${vnet2Name}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: vnet1isHub
    useRemoteGateways: vnet2isHub
    remoteVirtualNetwork: {
      id: vnet2ID
    }
  }
}
