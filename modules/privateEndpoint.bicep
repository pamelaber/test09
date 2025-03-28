// Module to create a private endpoint for a resource

param location string // Location of the private endpoint
param resourceId string // Resource ID of the target resource
param subnetId string // Subnet ID for the private endpoint
param privateDnsZoneName string // Private DNS zone name for the resource

// Create the private endpoint
resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-05-01' = {
  name: '${resourceId}-pe'
  location: location
  properties: {
    subnet: {
      id: subnetId // Reference the subnet for the private endpoint
    }
    privateLinkServiceConnections: [
      {
        name: '${resourceId}-connection'
        properties: {
          privateLinkServiceId: resourceId // Target resource for the private endpoint
          groupIds: []
        }
      }
    ]
  }
}

// Link the private endpoint to the private DNS zone
resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2021-05-01' = {
  name: '${privateEndpoint.name}/default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: privateDnsZoneName
        properties: {
          privateDnsZoneId: subscriptionResourceId('Microsoft.Network/privateDnsZones', privateDnsZoneName)
        }
      }
    ]
  }
}
