using 'azuredeploy.bicep'

param imageTemplateName = 'myTestImageTemplate'
param galleryImageId = '/subscriptions/ea9baa35-c4da-426f-9a40-d1398832ec55/resourceGroups/rg-imagebuilder-test/providers/Microsoft.Compute/galleries/cgimagebuildertest/images/myTestImageDefinition/versions/0.0.1'
param imageBuilderManagedIdentityId = '/subscriptions/ea9baa35-c4da-426f-9a40-d1398832ec55/resourceGroups/rg-imagebuilder-test/providers/Microsoft.ManagedIdentity/userAssignedIdentities/id-computegalleryaccess'

param sourceImage = {
  type: 'PlatformImage'
  publisher: 'resf'
  offer: 'rockylinux-x86_64'
  sku: '9-base'
  version: 'latest'
  planInfo: {
    planName: '9-base'
    planProduct: 'rockylinux-x86_64'
    planPublisher: 'resf'
  }
}
