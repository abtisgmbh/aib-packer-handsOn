//  variables.pkr.hcl

variable "client_id" {
  type = string
}

variable "client_secret" {
  type      = string
  sensitive = true
}

variable "subscription_id" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "resource_group" {
  type = string
}

variable "gallery_name" {
  type = string
}

variable "image_name" {
  type = string
}

variable "image_version" {
  type = string
}
