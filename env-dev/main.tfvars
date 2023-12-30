env  = "dev"

component ={

  frontend = {
    tags ={ Monitor ="true", env="dev"}
  }
  mongodb={
    tags ={ Monitor ="true", env="dev"}
  }
  catalogue={
    tags ={ Monitor ="true", env="dev"}
  }
  redis={
    tags ={  env="dev"}
  }
  user={
    tags ={ Monitor ="true", env="dev"}
  }
  cart={
    tags ={ Monitor ="true", env="dev"}
  }
  mysql={
    tags ={ env="dev"}
  }
  shipping={
    tags ={ Monitor ="true", env="dev"}
  }
  rabbitmq={
    tags ={ env="dev"}
  }
  payment={
    tags ={ Monitor ="true", env="dev"}
  }
  dispatch={
    tags ={ Monitor ="true", env="dev"}
  }

}

tags={
  company= "Xyz company"
  business= "ecommerce"
  business_unit= "retail"
  cost_center= "3221"
  project_name= "roboshop"
}