variable "location" {}

variable "environment" {}

variable "application_name" {}

variable "address_space" {
  default = "10.10.0.0/16"
}

variable "network" {
  description = "Subnet layout for network zones"

  default = {
    test_dmz = "10.10.0.0/24"
    test_app = "10.10.10.0/24"
    test_db  = "10.10.20.0/24"
    prod_dmz = "10.10.100.0/24"
    prod_app = "10.10.110.0/24"
    prod_db  = "10.10.120.0/24"
  }
}

variable "dns_servers" {
  default = ["10.10.0.7", "10.10.0.8"]
}
