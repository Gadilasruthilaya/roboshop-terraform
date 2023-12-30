module "instances" {
  for_each  = var.component
  source    = "git::https://github.com/Gadilasruthilaya/tf-module-app.git"
  component = each.key
  env       = var.env
  tags      = merge(each.value["tags"], var.tags)
}
  provider "aws" {
    region = "us-east-1"
  }

