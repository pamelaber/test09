// Module to deploy an Azure Function with VNet integration and no public access

param location string // Location of the Azure Function
param functionName string // Name of the Azure Function
param subnetId string // Subnet ID for VNet integration

// Deploy the App Service Plan (Premium Tier)
resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: '${functionName}-asp' // Name of the App Service Plan
  location: location
  sku: {
    name: 'EP1' // Elastic Premium tier (EP1, EP2, EP3)
    tier: 'PremiumV2'
    capacity: 1 // Number of instances
  }
  properties: {
    reserved: false // Set to true for Linux-based plans
  }
}

// Deploy the Azure Function
resource functionApp 'Microsoft.Web/sites@2022-03-01' = {
  name: functionName
  location: location
  identity: {
    type: 'SystemAssigned' // Use system-assigned managed identity for security
  }
  properties: {
    serverFarmId: appServicePlan.id // Reference the Premium App Service Plan
    siteConfig: {
      vnetRouteAllEnabled: true // Enable VNet routing for the function
    }
  }
}

// Integrate the Azure Function with the VNet
resource vnetIntegration 'Microsoft.Web/sites/virtualNetworkConnections@2022-03-01' = {
  name: '${functionApp.name}/vnet'
  properties: {
    subnetResourceId: subnetId // Reference the subnet for VNet integration
  }
}

output functionId string = functionApp.id // Output the Azure Function ID
