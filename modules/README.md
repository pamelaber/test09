# Azure Function and Key Vault in VNet

## Overview
This Bicep template deploys:
- An Azure Function with no public access, integrated into a Virtual Network.
- A Key Vault with private endpoint access only.
- Private endpoints for both resources to ensure secure communication.

## File Structure
- `main.bicep`: Main deployment file.
- `modules/azureFunction.bicep`: Deploys the Azure Function.
- `modules/keyVault.bicep`: Deploys the Key Vault.
- `modules/privateEndpoint.bicep`: Creates private endpoints.

## Prerequisites
- A Virtual Network with subnets already exists.
- Subnet IDs for the Azure Function and Key Vault must be provided.

## Deployment
Run the following command to deploy:
```bash
az deployment group create --resource-group <resource-group-name> --template-file main.bicep