targetScope = 'subscription'

param rgName string
param rgLocation string
param rgTags object = {}


resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: rgName
  location: rgLocation
  tags: rgTags
}
