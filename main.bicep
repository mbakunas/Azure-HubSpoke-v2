targetScope = 'subscription'

param resourceGroup_location string // Azure region for all deployed resource groups

param vnets array

// -----------------------------------------------------------------------------------------------------
// resource groups

// vnet & nsg
var vnetRgList = [for vnet in vnets: {
  name: vnet.resourceGroup.name
  tags: vnet.resourceGroup.tags
}]
var uniqueVnetRgList = union(vnetRgList, vnetRgList)  // make sure the list of resource groups is unique

resource resourceGroups 'Microsoft.Resources/resourceGroups@2021-04-01' = [for rg in uniqueVnetRgList: {
  name: rg.name
  location: resourceGroup_location
  tags: rg.tags
}]

// -----------------------------------------------------------------------------------------------------
// base neworking

// vnet and nsgs
@description('VNets, subnets, and default NSGs.  The first VNet is the hub.')
module deployVNets 'Modules/VNet.bicep' = [for (vnet, i) in vnets: {
  name: '${deployment().name}-VNet${i}'
  scope: resourceGroup(vnet.resourceGroup.name)
  dependsOn: resourceGroups
  params: {
    vnet_subnets: vnet.subnets
    vnet_AddressSpace: vnet.addressSpace
    vnet_Location: vnet.location
    vnet_Name: vnet.name
  }
}]

// nsg rules
@description('NSG Rules')
module nsgs 'Modules/NSGrules.bicep' = [for (vnet, i) in vnets: {
  scope: resourceGroup(vnet.resourceGroup.name)
  name: '${deployment().name}-NsgRules-for-VNet${i}'
  dependsOn: deployVNets
  params: {
    nsg_Subnets: vnet.subnets
  }
}]

// vnet peerings
@description('Spoke to hub peerings')
module hub2SpokePeer 'Modules/VNetPeer.bicep' = [for i in range(1, length(vnets)-1): {
  scope: resourceGroup(vnets[0].resourceGroup.name)  // resource group where the hub VNet lives
  name: '${deployment().name}-Peer-Outbound-${i}'
  dependsOn: deployVNets
  params: {
    peer_LocalVnetName: vnets[0].name  // hub VNet is first one deployed
    peer_ForeignVnetName: vnets[i].name
    peer_ForeighVnetResourceGroup: vnets[i].resourceGroup.name
    peer_allowGatewayTransit: false
    peer_useRemoteGateways: false
  }
}]

@description('Hub to spoke peerings')
module spoke2HubPeer 'Modules/VNetPeer.bicep' = [for i in range(1, length(vnets)-1): {
  scope: resourceGroup(vnets[i].resourceGroup.name)  // resource group where the specific spoke VNet lives
  name: '${deployment().name}-Peer-Inbound-${i}'
  dependsOn: deployVNets
  params: {
    peer_LocalVnetName: vnets[i].name
    peer_ForeignVnetName: vnets[0].name  // hub VNet is first one deployed
    peer_ForeighVnetResourceGroup: vnets[0].resourceGroup.name
    peer_allowGatewayTransit: false
    peer_useRemoteGateways: false
  }
}]

// -----------------------------------------------------------------------------------------------------
// network services
module services 'Modules/services.bicep' = [for (vnet, i) in vnets: {
  scope: resourceGroup(vnet.resourceGroup.name)
  name: '${deployment().name}-NetSvcs${i}'
  dependsOn: deployVNets
  params: {
    vnet: vnet
    location: vnet.location
  }
}]

