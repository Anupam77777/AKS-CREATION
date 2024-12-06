param location string
param nodeCount int 
param vmSize string 

resource aksCluster  'Microsoft.ContainerService/ManagedClusters@2023-02-01' = {
  name: 'myAKScluster'
  location: location
  properties: {
    kubernetesVersion: '1.26.11'
    nodeResourceGroup: 'MC_myAKScluster_eastus_nodepool1'
    networkProfile: {
      networkPlugin: 'kubenet'
    }
    agentPoolProfiles: [
      {
        name: 'nodepool1'
        count: nodeCount
        vmSize: vmSize
        osDiskSizeGB: 30
        osType: 'Linux'
        mode: 'SystemAssigned'
      }
    ]
  }
}

resource acr  'Microsoft.ContainerRegistry/registries@2023-08-01' = {
  name: 'myACR'
  location: location
  properties: {
    sku: 'Standard'
    adminUserEnabled: true
  }
}

// Link the ACR to the AKS cluster
resource aksAcrConfig  'Microsoft.ContainerService/ManagedClusters/containerRegistries@2023-02-01' = {
  parent: aksCluster
  name: 'myACR'
  properties: {
    loginServer: acr.properties.loginServer
    password: acr.properties.adminPassword
  }
}