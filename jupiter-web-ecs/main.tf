provider "aws" {
  region  = var.region
  profile = "terraform-user1"

}

# create vpc    
module "vpc" {
  source                       = "../Module/VPC"
  region                       = var.region
  project_name                 = var.project_name
  vpc_cidr                     = var.vpc_cidr
  public_subnet_az1_cidr       = var.public_subnet_az1_cidr
  public_subnet_az2_cidr       = var.public_subnet_az2_cidr
  private_app_subnet_az1_cidr  = var.private_app_subnet_az1_cidr
  private_app_subnet_az2_cidr  = var.private_app_subnet_az2_cidr
  private_data_subnet_az1_cidr = var.private_data_subnet_az1_cidr
  private_data_subnet_az2_cidr = var.private_data_subnet_az2_cidr


}

# create nat gateway
module "nat-gateway" {
  source                     = "../Module/nat-gateway"
  vpc_id                     = module.vpc.vpc_id
  public_subnet_az1_id       = module.vpc.public_subnet_az1_id
  public_subnet_az2_id       = module.vpc.public_subnet_az2_id
  private_app_subnet_az1_id  = module.vpc.private_app_subnet_az1_id
  private_app_subnet_az2_id  = module.vpc.private_app_subnet_az2_id
  private_data_subnet_az1_id = module.vpc.private_data_subnet_az1_id
  private_data_subnet_az2_id = module.vpc.private_data_subnet_az2_id
  internet_gateway           = module.vpc.internet_gateway

}

# create security groups
module "security-groups" {
  source = "../Module/security-groups"
  vpc_id = module.vpc.vpc_id

}


# create ec2 task definitions
module "ecs" {
  source       = "../Module/ecs"
  project_name = module.vpc.project_name
}