variable "location" {
  #  default = "centralus"
}

variable "environment" {
  #  default = "dev"
}

variable "application_name" {
  #  default = "themis"
}

variable "address_space" {
  #  default = "10.10.0.0/16"
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
