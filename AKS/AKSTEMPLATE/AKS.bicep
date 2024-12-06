@description('Name of the AKS cluster')
param aksClusterName string = 'myAKSCluster'

@description('Name of the resource group')
param resourceGroupName string = 'myResourceGroup'

@description('Location for the resources')
param location string = 'East US'

@description('The size of the Virtual Machine')
param vmSize string = 'Standard_DS2_v2'

@description('The number of nodes in the node pool')
param nodeCount int = 2

resource aksCluster 'Microsoft.ContainerService/managedClusters@2021-05-01' = {
  name: aksClusterName
  location: location
  properties: {
    kubernetesVersion: '1.20.9'
    dnsPrefix: 'aksdns'
    agentPoolProfiles: [
      {
        name: 'nodepool1'
        count: nodeCount
        vmSize: vmSize
        osType: 'Linux'
        mode: 'System'
        type: 'VirtualMachineScaleSets'
        availabilityZones: [
          '1'
          '2'
          '3'
        ]
      }
    ]
    networkProfile: {
      networkPlugin: 'kubenet'
    }
    identity: {
      type: 'SystemAssigned'
    }
  }
}

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  name: resourceGroupName
}

output kubeConfig string = aksCluster.properties.kubeConfig