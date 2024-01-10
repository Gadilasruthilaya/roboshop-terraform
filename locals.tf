locals {
  app_web_cidr_block=  concat(lookup(lookup(lookup(lookup(var.vpc, "main" , null ), "subnets", null), "app" , null), "cidr_block", null),lookup(lookup(lookup(lookup(var.vpc, "main" , null ), "subnets", null), "web" , null), "cidr_block", null))
}