#module "instances" {
#  for_each  = var.component
#  source    = "git::https://github.com/Gadilasruthilaya/tf-module-app.git"
#  component = each.key
#  env       = var.env
#  tags      = merge(each.value["tags"], var.tags)
#}
  provider "aws" {
    region = "us-east-1"
  }

module "vpc"{
  source = "git::https://github.com/Gadilasruthilaya/tf-module-vpc.git"
  for_each = var.vpc
  cidr_block = each.value["cidr_block"]
  env = var.env
  subnets = each.value["subnets"]
  tags = var.tags
  default_vpc_id = var.default_vpc_id
}

module "app"{
  source = "git::https://github.com/Gadilasruthilaya/tf-module-app.git"
  env = var.env
  tags = var.tags
  component = "test"
  subnet_id = lookup(lookup(lookup(lookup(module.vpc, "main" , null ), "subnet_ids", null), "app" , null), "subnet_ids",null)[0]
  vpc_id = lookup(lookup(module.vpc, "main", null ), "vpc_id" , null)
}

