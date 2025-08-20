packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 2"
    }
  }
}


source "azure-arm" "my-test" {

  client_id                         = var.client_id
  client_secret                     = var.client_secret
  subscription_id                   = var.subscription_id
  tenant_id                         = var.tenant_id
  image_offer                       = "rockylinux-x86_64"
  image_publisher                   = "resf"
  image_sku                         = "9-base"
  location                          = "westeurope"
  managed_image_name                = "myTestImageTemplatePacker"
  managed_image_resource_group_name = "rg-imagebuilder-test"
  os_type                           = "Linux"
  vm_size                           = "Standard_DS1_v2"
  plan_info {
    plan_name      = "9-base"
    plan_product   = "rockylinux-x86_64"
    plan_publisher = "resf"
  }
  shared_image_gallery_destination {
    subscription   = var.subscription_id
    resource_group = var.resource_group
    gallery_name   = var.gallery_name
    image_name     = var.image_name
    image_version  = var.image_version
  }
}

build {
  sources = ["source.azure-arm.my-test"]

  provisioner "shell" {
    inline = [
      "sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo",
      "sudo dnf -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin",
      "sudo systemctl --now enable docker",
      "sudo usermod -a -G docker $(whoami)"
    ]
  }
}