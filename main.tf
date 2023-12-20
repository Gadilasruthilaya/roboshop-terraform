module "instances" {
  for_each  = var.component
  source    = "git::https://github.com/Gadilasruthilaya/tf-module-app.git"
  component = each.key
  env       = var.env

}
  provider "aws" {
    region = "us-west-1"
  }

