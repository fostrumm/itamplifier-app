param location string = resourceGroup().location
param acrName string = 'itamplifierregistry'

// 1. De Registry (opslag voor je images)
resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: acrName
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: false
  }
}

// 2. De Environment (het 'park' voor je apps)
resource environment 'Microsoft.App/managedEnvironments@2024-03-01' = {
  name: 'itamplifier-env'
  location: location
  properties: {}
}

// 3. De Container App (de eigenlijke server)
resource containerApp 'Microsoft.App/containerApps@2024-03-01' = {
  name: 'itamplifier-app'
  location: location
  identity: {
    type: 'SystemAssigned' // De app krijgt een eigen automatisch paspoort (Identity)
  }
  properties: {
    managedEnvironmentId: environment.id
    configuration: {
      ingress: {
        external: true
        targetPort: 80 // De placeholder image luistert op poort 80, wordt later bijgewerkt naar 5000
      }
      registries: [
        {
          server: acr.properties.loginServer
          identity: 'system' // Vertel de app om zijn eigen paspoort te gebruiken voor de registry
        }
      ]
    }
    template: {
      containers: [
        {
          name: 'python-app'
          image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
          resources: {
            cpu: json('0.25')
            memory: '0.5Gi'
          }
        }
      ]
    }
  }
}

// 4. Toestemming geven (AcrPull rol)
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(acr.id, containerApp.id, 'AcrPull')
  scope: acr
  properties: {
    principalId: containerApp.identity.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-a505-4baa-b778-4a64283c7102') // ID voor AcrPull
    principalType: 'ServicePrincipal'
  }
}
