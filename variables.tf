variable "cidr_vpc" {
  default = "10.0.0.0/16"
}

variable "cidr_sub1" {
  default = "10.0.1.0/24"
}

variable "cidr_sub2" {
  default = "10.0.2.0/24"
}

variable "sub1_zone" {
  default = "us-east-1a"
}

variable "sub2_zone" {
  default = "us-east-1b"
}

variable "ami_new" {
  default = "ami-04b70fa74e45c3917"
}