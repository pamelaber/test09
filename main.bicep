// Main deployment file to orchestrate the deployment of Azure Function, Key Vault, and Private Endpoints

param location string = resourceGroup().location // Location of the resources
param functionName string = 'myAzureFunction'    // Name of the Azure Function
param keyVaultName string = 'myKeyVault'         // Name of the Key Vault
param functionSubnetId string                    // Subnet ID for Azure Function
param keyVaultSubnetId string                    // Subnet ID for Key Vault

// Deploy the Azure Function
module azureFunction './modules/azureFunction.bicep' = {
  name: 'azureFunctionDeployment'
  params: {
    location: location
    functionName: functionName
    subnetId: functionSubnetId
  }
}

// Deploy the Key Vault
module keyVault './modules/keyVault.bicep' = {
  name: 'keyVaultDeployment'
  params: {
    location: location
    keyVaultName: keyVaultName
    subnetId: keyVaultSubnetId
  }
}

// Create a private endpoint for the Azure Function
module functionPrivateEndpoint './modules/privateEndpoint.bicep' = {
  name: 'functionPrivateEndpointDeployment'
  params: {
    location: location
    resourceId: azureFunction.outputs.functionId
    subnetId: functionSubnetId
    privateDnsZoneName: 'privatelink.azurewebsites.net'
  }
}

// Create a private endpoint for the Key Vault
module keyVaultPrivateEndpoint './modules/privateEndpoint.bicep' = {
  name: 'keyVaultPrivateEndpointDeployment'
  params: {
    location: location
    resourceId: keyVault.outputs.keyVaultId
    subnetId: keyVaultSubnetId
    privateDnsZoneName: 'privatelink.vaultcore.azure.net'
  }
}
