param location string = resourceGroup().location
param acrName string = 'itamplifierregistry' // Let op: geen streepjes in de naam!

// 1. De Registry (opslag voor je images)
resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: acrName
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true 
  }
}

// 2. De Environment (het 'park' voor je apps)
resource environment 'Microsoft.App/managedEnvironments@2024-03-01' = {
  name: 'itamplifier-env'
  location: location
}

// 3. De Container App (de eigenlijke server)
resource containerApp 'Microsoft.App/containerApps@2024-03-01' = {
  name: 'itamplifier-app'
  location: location
  properties: {
    managedEnvironmentId: environment.id
    configuration: {
      ingress: {
        external: true
        targetPort: 5000
      }
    }
    template: {
      containers: [
        {
          name: 'python-app'
          image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
        }
      ]
    }
  }
}
