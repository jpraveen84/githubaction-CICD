variable "vpc_cidr" {
    type = string
    description = "testing"
}

variable "pearl_sg" {
    type = list
    default = ["0.0.0.0/0"]
}

variable "pearl_sg_port" {
    
    type = list(string)
    default = ["80"]
}

locals {
  tags = {
    Created_By  = "Terraform"
    Environment = "DEMO"
    Application = "Pearl"
  }
}