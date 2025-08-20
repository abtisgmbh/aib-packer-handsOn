param imageTemplateName string
param location string = resourceGroup().location
param galleryImageId string
param imageBuilderManagedIdentityId string
param sourceImage object

resource imageTemplate 'Microsoft.VirtualMachineImages/imageTemplates@2022-07-01' = {
  name: imageTemplateName
  location: location
  tags: {}
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${imageBuilderManagedIdentityId}': {}
    }
  }
  properties: {
    vmProfile: {
      vmSize: 'Standard_DS1_v2'
      osDiskSizeGB: 10
      userAssignedIdentities: []
    }
    source: sourceImage
    distribute: [
      {
        type: 'SharedImage'
        galleryImageId: galleryImageId
        replicationRegions: [
          'westeurope'
        ]
        excludeFromLatest: false
        runOutputName: 'runOutputImageVersion'
      }
    ]
    customize: [
      {
        type: 'Shell'
        name: 'Install Docker'
        inline: [
          'sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo'
          'sudo dnf -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin'
          'sudo systemctl --now enable docker'
          'sudo usermod -a -G docker $(whoami)'
        ]
      }
    ]
  }
  dependsOn: []
}
