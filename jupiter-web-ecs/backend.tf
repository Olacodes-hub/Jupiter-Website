terraform {
  backend "s3" {
    bucket  = "safo-terraform-state"
    key     = "terraform-web-ecs.tfstate"
    region  = "us-east-1"
    profile = "terraform-user1"
  }
}