using 'hub-spoke-deploy.bicep'

param vnets = [
  {
    name: 'VNET-CENTRALUS-HUB-01'
    resourceGroupName: 'HubSpokeTest01'
    resourceGroupLocation: 'eastus2'
    resourceGroupSubscriptionID: 'f0bb6c48-80fd-445c-98cb-c38b5f817d52'
    location: 'centralus'
    addressPrefix: '10.10.0.0/16'
    dnsServers: [
      '100.0.0.100'
      '100.0.0.101'
    ]
    gateway: {
      name: 'VNET-CENTRALUS-HUB-01-GW01'
      type: 'ExpressRoute'
      sku: 'Standard'
      publicIPName: 'VNET-CENTRALUS-HUB-01-GW01-PIP'
    }
    subnets: [
      {
        name: 'gatewaySubnet'
        addressPrefix: '10.10.0.0/27'
        routeTable: 'RT-CENTRALUS-HUB-01-gatewaySubnet'
      }
      {
        name: 'Public'
        addressPrefix: '10.10.0.32/28'
      }
      {
        name: 'Private'
        addressPrefix: '10.10.0.48/28'
      }
      {
        name: 'FwMgmt'
        addressPrefix: '10.10.0.64/27'
      }
      {
        name: 'Corpnet00'
        addressPrefix: '10.10.0.96/27'
      }
    ]
    routeTable: {
      name: 'RT-CENTRALUS-HUB-01-gatewaySubnet'
      disableBgpRoutePropagation: false
      routes: [
        {
          name: 'Spoke-01'
          properties: {
            addressPrefix: '10.11.0.0/17'
            nextHopType: 'VirtualAppliance'
            nextHopIpAddress: '10.10.0.36'
          }
        }
        {
          name: 'Spoke-02'
          properties: {
            addressPrefix: '10.12.0.0/17'
            nextHopType: 'VirtualAppliance'
            nextHopIpAddress: '10.10.0.36'
          }
        }
        {
          name: 'Spoke-03'
          properties: {
            addressPrefix: '10.13.0.0/17'
            nextHopType: 'VirtualAppliance'
            nextHopIpAddress: '10.10.0.36'
          }
        }
      ]
    }
  }
  {
    name: 'VNET-CENTRALUS-Spoke-01'
    resourceGroupName: 'HubSpokeTest01'
    resourceGroupLocation: 'eastus2'
    resourceGroupSubscriptionID: 'c64ca001-2cce-46de-837e-03f5564fc802'
    location: 'centralus'
    addressPrefix: '10.11.0.0/16'
    dnsServers: [
      '100.0.0.100'
      '100.0.0.101'
    ]
    subnets: [
      {
        name: 'Corpnet01'
        addressPrefix: '10.11.0.0/17'
        routeTable: 'RT-CENTRALUS-Spoke-01-Corpnet01'
      }
    ]
    routeTable: {
      name: 'RT-CENTRALUS-Spoke-01-Corpnet01'
      disableBgpRoutePropagation: true
      routes: [
        {
          name: 'default'
          properties: {
            addressPrefix: '0.0.0.0/0'
            nextHopType: 'VirtualAppliance'
            nextHopIpAddress: '10.10.0.52'
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
    }
  }
  {
    name: 'VNET-CENTRALUS-Spoke-02'
    resourceGroupName: 'HubSpokeTest01'
    resourceGroupLocation: 'eastus2'
    resourceGroupSubscriptionID: '16936380-29b0-4326-8f6b-db86da154736'
    location: 'centralus'
    addressPrefix: '10.12.0.0/16'
    dnsServers: [
      '100.0.0.100'
      '100.0.0.101'
    ]
    subnets: [
      {
        name: 'Corpnet02'
        addressPrefix: '10.12.0.0/17'
        routeTable: 'RT-CENTRALUS-Spoke-01-Corpnet01'
      }
    ]
    routeTable: {
      name: 'RT-CENTRALUS-Spoke-01-Corpnet01'
      disableBgpRoutePropagation: true
      routes: [
        {
          name: 'default'
          properties: {
            addressPrefix: '0.0.0.0/0'
            nextHopType: 'VirtualAppliance'
            nextHopIpAddress: '10.10.0.52'
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
    }
  }
  {
    name: 'VNET-CENTRALUS-Spoke-03'
    resourceGroupName: 'HubSpokeTest01'
    resourceGroupLocation: 'eastus2'
    resourceGroupSubscriptionID: '93ebbf00-49a3-49cf-acd2-e4a848c1da2e'
    location: 'centralus'
    addressPrefix: '10.13.0.0/16'
    dnsServers: [
      '100.0.0.100'
      '100.0.0.101'
    ]
    subnets: [
      {
        name: 'Corpnet03'
        addressPrefix: '10.13.0.0/17'
        routeTable: 'RT-CENTRALUS-Spoke-01-Corpnet01'
      }
    ]
    routeTable: {
      name: 'RT-CENTRALUS-Spoke-01-Corpnet01'
      disableBgpRoutePropagation: true
      routes: [
        {
          name: 'default'
          properties: {
            addressPrefix: '0.0.0.0/0'
            nextHopType: 'VirtualAppliance'
            nextHopIpAddress: '10.10.0.52'
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
    }
  }
]
param tags = {
  location: 'centralus'
  environment: 'non-prod'
  chargeCode: '42'
  runTime: '24x7'
}
param resourceGroupTags = {
  location: 'eastus2'
  environment: 'non-prod'
  chargeCode: '42'
  runTime: '24x7'
}
