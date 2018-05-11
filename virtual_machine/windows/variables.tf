variable "rg" {}
variable "location" {}
variable "environment" {}
variable "application_name" {}
variable "subnet_id" {}
variable "hostname" {}
variable "admin_password" {}
variable "security_group" {}

variable "number_servers" {
  default = "1"
}
