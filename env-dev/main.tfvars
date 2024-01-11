


env  = "dev"

tags = {
  company= "Xyz company"
  business= "ecommerce"
  business_unit= "retail"
  cost_center= "3221"
  project_name= "roboshop"
}

vpc = {
  main ={
    cidr_block = "10.0.0.0/16"
    subnets = {
      web = {
        cidr_block = ["10.0.0.0/24", "10.0.1.0/24"]
      }
      app ={
        cidr_block = ["10.0.2.0/24", "10.0.3.0/24"]
      }
      db ={
        cidr_block = ["10.0.4.0/24", "10.0.5.0/24"]
      }
      public ={
        cidr_block = ["10.0.6.0/24", "10.0.7.0/24"]
      }
    }
  }
}

default_vpc_id = "vpc-0785c748739da1093"
default_route_id= "rtb-007cec02789047c57"
zone_id = "Z02630002CU3WENE8SD4L"
allow_ssh_cidr = ["172.31.87.103/32"]
kms_id ="f6210ff7-c501-4ec2-a59c-9a3a2354d155"
kms_key_arn = "arn:aws:kms:us-east-1:190338077320:key/f6210ff7-c501-4ec2-a59c-9a3a2354d155"

rabbitmq = {
  main = {
    instance_type = "t3.small"
    component = "rabbitmq"
  }
}

rds ={
  main ={
    engine                  = "aurora-mysql"
    engine_Version          = "5.7.mysql_aurora.2.11.4"
    component               =  "mysql"
    db_name = "dummy"
    instance_count = 1
    instance_class = "db.t3.small"
    skip_final_snapshot = true
  }
}

elasticache ={
  main ={
    component = "elasticache"
    node_type                  = "cache.t2.small"
    parameter_group_name       = "default.redis6.x.cluster.on"
    num_node_groups         = 2
    replicas_per_node_group = 1
    engine                  = "redis"
    engine_version          ="6.x"
    node_type               = "cache.t3.micro"
  }
}

documentdb={
  main ={
    engine                  = "docdb"
    component               =  "docdb"
    instance_class          = "db.t3.medium"
    instance_count          =  1
    engine_version          = "4.0.0"
  }
}

alb = {
  public ={
    name = "public"
    internal           = false
    load_balancer_type = "application"
    subnet_refs     = "public"

  }

  private = {
    name ="private"
    internal           = true
    load_balancer_type = "application"
    subnet_refs     = "app"


  }

}

apps ={

  main ={
    component          = "cart"
    desired_capacity   = 1
    max_size           = 1
    min_size           = 1
    instance_type      = "t3.small"
    subnet_refs        = "app"
    app_port           = 8080
    lb_refs            = "private"
    priority           = 100
  }
}

