@description('Name of the AKS cluster')
param aksClusterName string 

@description('Location for the resources')
param location string

@description('The size of the Virtual Machine')
param vmSize string 

@minValue(0)
@maxValue(1023)
param osDiskSizeGB init = 0

@description('The number of nodes in the node pool')
param nodeCount int = 2



resource aksCluster 'Microsoft.ContainerService/managedClusters@2023-07-02-preview' = {
  name: aksClusterName
  location: location
  properties: {
    kubernetesVersion: '1.26.11'
    dnsPrefix: 'aksdns'
    agentPoolProfiles: [
      {
        name: 'nodepool1'
        osDiskSizeGB: osDiskSizeGB
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


output controlplaneFQDN string = aksCluster.properties.fqdn