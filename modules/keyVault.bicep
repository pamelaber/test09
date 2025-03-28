// Module to deploy a Key Vault with private access only

param location string // Location of the Key Vault
param keyVaultName string // Name of the Key Vault
param subnetId string // Subnet ID for private access

// Deploy the Key Vault
resource keyVault 'Microsoft.KeyVault/vaults@2021-10-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard' // Standard SKU for Key Vault
    }
    tenantId: subscription().tenantId // Use the tenant ID of the subscription
    accessPolicies: [] // No access policies defined initially
    networkAcls: {
      defaultAction: 'Deny' // Deny all public access
      bypass: 'None' // No bypass rules
      virtualNetworkRules: [
        {
          id: subnetId // Allow access only from the specified subnet
        }
      ]
    }
  }
}

output keyVaultId string = keyVault.id // Output the Key Vault ID
