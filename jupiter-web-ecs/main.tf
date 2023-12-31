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

module "alb" {
  source               = "../Module/ALB"
  project_name         = module.vpc.project_name
  alb_sg_id            = module.security-groups.alb_sg_id
  public_subnet_az1_id = module.vpc.public_subnet_az1_id
  public_subnet_az2_id = module.vpc.public_subnet_az2_id
  certificate_arn      = var.certificate_arn
  vpc_id               = module.vpc.vpc_id

}

module "ecs-cluster" {
  source                      = "../module/ecs-cluster"
  project_name                = module.vpc.project_name
  ecs_task_execution_role_arn = module.ecs.ecs_task_execution_role_arn
  container_image             = var.container_image
  region                      = module.vpc.region
  private_app_subnet_az1_id   = module.vpc.private_app_subnet_az1_id
  private_app_subnet_az2_id   = module.vpc.private_app_subnet_az2_id
  webserver_sg_id             = module.security-groups.webserver_sg_id
  alb_tg_arn                  = module.alb.alb_tg_arn

}