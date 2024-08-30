using './vnet.bicep'

param vnetName = 'VNET-EASTUS2-HUB-01'
param vnetLocation = 'eastus2'
param vnetAddressPrefix = '10.0.0.0/23'
param vnetDnsServers = [
      '100.0.0.100'
      '100.0.0.101'
    ]
param vnetEncryption = false
param vnetSubnets = [
      {
        name: 'gatewaySubnet'
        addressPrefix: '10.0.0.0/27'
        routeTable: 'RT-EASTUS2-HUB-01-gatewaySubnet'
      }
      {
        name: 'CorpNet'
        addressPrefix: '10.0.1.0/24'
      }
    ]
param vnetTags = {
  location: 'eastus2'
  environment: 'non-prod'
  chargeCode: '42'
  runTime: '24x7'
}

