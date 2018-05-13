variable "resource_group" {}

variable "location" {}

variable "environment" {}

variable "application_name" {}

variable "subnet_id" {}

variable "ssh_public_key" {}

variable "admin_username" {
  default = "azure"
}
