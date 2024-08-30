targetScope = 'resourceGroup'

param vnetName string
param vnetLocation string
param vnetAddressPrefix string
param vnetDnsServers array
param vnetEncryption bool
param vnetSubnets array 
param vnetTags object

resource vnet 'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: vnetName
  location: vnetLocation
  tags: vnetTags
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    dhcpOptions: !empty(vnetDnsServers)
    ? {
      dnsServers: vnetDnsServers
    }
    : null
    encryption: vnetEncryption == true
    ? {
      enabled: false
    }
    : null
    subnets: [
      for subnet in vnetSubnets: {
        name: subnet.name
        properties: {
          addressPrefix: subnet.addressPrefix
          routeTable: (contains(subnet, 'routeTable')
            ? {
                id: resourceId('Microsoft.Network/routeTables', subnet.routeTable)
              }
            : null)
        }
      }
    ]
  }
}

output id string = vnet.id
output subnets array = [for subnet in vnetSubnets: { id: '${vnet.id}/subnets/${subnet.name}' }]
