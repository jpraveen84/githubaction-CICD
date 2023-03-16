terraform {
  required_version = ">= 1.0.1"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.20.1"
    }
  }
}


provider "aws" {
    region = "eu-west-1"
    shared_credentials_file = "/Users/devops/.aws/credentials"
    profile = "staging"
    
}

module "pearlVPC" {
    source = "./modules/vpc"
    vpc_cidr = var.cidr
}

module "pearlALB" {
      source = "./modules/alb"
      subnets = module.pearlVPC.publicsubnet
      sgID = [module.pearlVPC.sgID]
      vpcID = module.pearlVPC.vpcID
}

module "ecsIAM" {
      source = "./modules/iam"
}

module "pearlECS" {
      source = "./modules/ecs"
      name = "pearlCluster"
      role = module.ecsIAM.roleARN
      tg = module.pearlALB.tgARN
      subnet = module.pearlVPC.publicsubnet
      ecsSG = [module.pearlVPC.ecsSG]
}