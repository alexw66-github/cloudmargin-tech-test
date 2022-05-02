variable "environment" {
  default = "test"
}

variable "availability_zones" {
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "cidr" {
  default = "10.0.0.0/16"
}

variable "private_subnets" {
  default = ["10.0.0.0/20", "10.0.32.0/20", "10.0.64.0/20"]
}

variable "public_subnets" {
  default = ["10.0.16.0/20", "10.0.48.0/20", "10.0.80.0/20"]
}

variable "container_port" {
  default = 80
}