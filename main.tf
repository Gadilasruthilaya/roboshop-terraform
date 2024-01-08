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
  default_route_id = var.default_route_id
}

#module "app"{
#  source = "git::https://github.com/Gadilasruthilaya/tf-module-app.git"
#  env = var.env
#  tags = var.tags
#  component = "test"
#  subnet_id = lookup(lookup(lookup(lookup(module.vpc, "main" , null ), "subnet_ids", null), "app" , null), "subnet_ids",null)[0]
#  vpc_id = lookup(lookup(module.vpc, "main", null ), "vpc_id" , null)
#}
#
#module "rabbitmq"{
#  source = "git::https://github.com/Gadilasruthilaya/tf-module-rabbitmq.git"
#  for_each = var.rabbitmq
#  env = var.env
#  tags = var.tags
#  component = each.value["component"]
#  instance_type = each.value["instance_type"]
#  vpc_id = lookup(lookup(module.vpc, "main", null ), "vpc_id" , null)
#  sg_subnet_cidr = lookup(lookup(lookup(lookup(var.vpc, "main" , null ), "subnets", null), "app" , null), "cidr_block", null)
#  subnet_id =  lookup(lookup(lookup(lookup(module.vpc, "main" , null ), "subnet_ids", null), "db" , null), "subnet_ids", null)[0]
#  allow_ssh_cidr = var.allow_ssh_cidr
#  zone_id = var.zone_id
#  kms_id = var.kms_id
#
#}
#module "rds"{
#  source = "git::https://github.com/Gadilasruthilaya/tf-module-rds.git"
#  for_each = var.rds
#  component = each.value["component"]
#  env = var.env
#  tags = var.tags
#  engine = each.value["engine"]
#  engine_Version = each.value["engine_Version"]
#  db_name = each.value["db_name"]
#  subnet_ids =  lookup(lookup(lookup(lookup(module.vpc, "main" , null ), "subnet_ids", null), "db" , null), "subnet_ids", null)
#  sg_subnet_cidr = lookup(lookup(lookup(lookup(var.vpc, "main" , null ), "subnets", null), "app" , null), "cidr_block", null)
#  vpc_id = lookup(lookup(module.vpc, "main", null ), "vpc_id" , null)
#  kms_key_arn = var.kms_key_arn
#  instance_count = each.value["instance_count"]
#  instance_class= each.value["instance_class"]
#  skip_final_snapshot = each.value["skip_final_snapshot"]
#}

module "elasticache" {
  source = "git::https://github.com/Gadilasruthilaya/tf-module-elastic-cache.git"
  for_each = var.elasticache
  component = each.value["component"]
  env = var.env
  tags = var.tags
  node_type                  = each.value["node_type"]
  parameter_group_name       = each.value["parameter_group_name"]
  num_node_groups            = each.value["num_node_groups"]
  replicas_per_node_group    = each.value["replicas_per_node_group"]
  engine                     = each.value["engine"]
  engine_version             = each.value["engine_version"]
  subnet_ids =  lookup(lookup(lookup(lookup(module.vpc, "main" , null ), "subnet_ids", null), "db" , null), "subnet_ids", null)
  sg_subnet_cidr = lookup(lookup(lookup(lookup(var.vpc, "main" , null ), "subnets", null), "app" , null), "cidr_block", null)
  vpc_id = lookup(lookup(module.vpc, "main", null ), "vpc_id" , null)
  kms_key_arn = var.kms_key_arn
}


module "documentdb" {
  source = "git::https://github.com/Gadilasruthilaya/tf-module-documentdb.git"
  for_each = var.documentdb
  component = each.value["component"]
  env                        = var.env
  tags                       = var.tags
  engine                     = each.value["engine"]
  engine_version             = each.value["engine_version"]
  instance_count             = each.value["instance_count"]
  instance_class             = each.value["instance_class"]
  subnet_ids =  lookup(lookup(lookup(lookup(module.vpc, "main" , null ), "subnet_ids", null), "db" , null), "subnet_ids", null)
  sg_subnet_cidr = lookup(lookup(lookup(lookup(var.vpc, "main" , null ), "subnets", null), "app" , null), "cidr_block", null)
  vpc_id = lookup(lookup(module.vpc, "main", null ), "vpc_id" , null)
  kms_key_arn = var.kms_key_arn

}





