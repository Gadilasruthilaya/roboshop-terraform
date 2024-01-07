env  = "dev"

component ={

  frontend = {
    tags = { Monitor ="true", env="dev"}
  }
  mongodb={
    tags = { env="dev"}
  }
  catalogue={
    tags = { Monitor ="true", env="dev"}
  }
  redis={
    tags = {  env="dev"}
  }
  user={
    tags = { Monitor ="true", env="dev"}
  }
  cart={
    tags = { Monitor ="true", env="dev"}
  }
  mysql={
    tags = { env="dev"}
  }
  shipping={
    tags = { Monitor ="true", env="dev"}
  }
  rabbitmq={
    tags = { env="dev"}
  }
  payment={
    tags = { Monitor ="true", env="dev"}
  }
  dispatch={
    tags = { Monitor ="true", env="dev"}
  }

}

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
    subnets={
      web ={
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
Kms_arn = "arn:aws:kms:us-east-1:190338077320:key/f6210ff7-c501-4ec2-a59c-9a3a2354d155"

rabbitmq = {
  main = {
    instance_type = "t3.small"
    component = "rabbitmq"
  }
}

rds ={
  main ={
    component = " mysql "
    engine                  = "aurora-mysql"
    engine_Version          = "Aurora MySQL 3.04.0 (compatible with MySQL 8.0.28)"
    db_name = "dummy"
    instance_count = 1
    instance_class = "db_t3_small"
  }
}