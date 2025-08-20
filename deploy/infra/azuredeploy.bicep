param galleryImageId string
param imageBuilderManagedIdentityId string
param imageTemplateName string
param sourceImage object

module imageTemplate 'modules/imageTemplate.bicep' = {
  name: 'imageTemplate'
  params: {
    galleryImageId: galleryImageId
    imageBuilderManagedIdentityId: imageBuilderManagedIdentityId
    imageTemplateName: imageTemplateName
    sourceImage: sourceImage
  }
}
