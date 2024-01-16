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


module "rabbitmq"{
  source = "git::https://github.com/Gadilasruthilaya/tf-module-rabbitmq.git"
  for_each = var.rabbitmq
  env = var.env
  tags = var.tags
  component = each.value["component"]
  instance_type = each.value["instance_type"]
  vpc_id = lookup(lookup(module.vpc, "main", null ), "vpc_id" , null)
  sg_subnet_cidr = lookup(lookup(lookup(lookup(var.vpc, "main" , null ), "subnets", null), "app" , null), "cidr_block", null)
  subnet_id =  lookup(lookup(lookup(lookup(module.vpc, "main" , null ), "subnet_ids", null), "db" , null), "subnet_ids", null)[0]
  allow_ssh_cidr = var.allow_ssh_cidr
  zone_id = var.zone_id
  kms_key_arn = var.kms_key_arn
}
module "rds"{
  source = "git::https://github.com/Gadilasruthilaya/tf-module-rds.git"
  for_each = var.rds
  component = each.value["component"]
  env = var.env
  tags = var.tags
  engine = each.value["engine"]
  engine_Version = each.value["engine_Version"]
  db_name = each.value["db_name"]
  subnet_ids =  lookup(lookup(lookup(lookup(module.vpc, "main" , null ), "subnet_ids", null), "db" , null), "subnet_ids", null)
  sg_subnet_cidr = lookup(lookup(lookup(lookup(var.vpc, "main" , null ), "subnets", null), "app" , null), "cidr_block", null)
  vpc_id = lookup(lookup(module.vpc, "main", null ), "vpc_id" , null)
  kms_key_arn = var.kms_key_arn
  instance_count = each.value["instance_count"]
  instance_class= each.value["instance_class"]
  skip_final_snapshot = each.value["skip_final_snapshot"]
}

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


module "alb" {
  source = "git::https://github.com/Gadilasruthilaya/tf-module-alb.git"
  for_each = var.alb
  name = each.value["name"]
  internal = each.value["internal"]
  load_balancer_type = each.value["load_balancer_type"]
  env                        = var.env
  tags                       = var.tags
  vpc_id = lookup(lookup(module.vpc, "main", null ), "vpc_id" , null)
  sg_subnet_cidr = each.value["name"] == "public" ? ["0.0.0.0/0"] : local.app_web_cidr_block
  subnets =  lookup(lookup(lookup(lookup(module.vpc, "main" , null ), "subnet_ids", null), each.value["subnet_refs"] , null), "subnet_ids", null)


}

module "app_server"{
  depends_on = [module.vpc,module.rabbitmq, module.documentdb, module.elasticache, module.alb, module.rds]
  source = "git::https://github.com/Gadilasruthilaya/tf-module-app.git"
  for_each = var.apps
  desired_capacity =each.value["desired_capacity"]
  max_size  = each.value["max_size"]
  min_size = each.value["min_size"]
  instance_type = each.value["instance_type"]
  env = var.env
  tags = var.tags
  component = each.value["component"]
  sg_subnet_cidr = each.value["component"] == "frontend" ? local.public_web_cidr_block : lookup(lookup(lookup(lookup(var.vpc, "main" , null ), "subnets", null), each.value["subnet_refs"] , null), "cidr_block", null)
  vpc_id = lookup(lookup(module.vpc, "main", null ), "vpc_id" , null)
  subnets =  lookup(lookup(lookup(lookup(module.vpc, "main" , null ), "subnet_ids", null), each.value["subnet_refs"] , null), "subnet_ids", null)
  kms_id = var.kms_key_arn
  allow_ssh_cidr = var.allow_ssh_cidr
  app_port = each.value["app_port"]
  lb_dns_name =  lookup(lookup(module.alb, each.value["lb_refs"], null ), "dns_name", null)
  listener_arn =  lookup(lookup(module.alb, each.value["lb_refs"], null ), "listener_arn", null)
  priority = each.value["priority"]
  kms_key_arn = var.kms_key_arn
  extra_param_access = try(each.value["extra_param_access"],[])
}













