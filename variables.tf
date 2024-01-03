variable "env" {}
variable "component" {}
variable "tags"{
  default = {}
}
variable "vpc" {}
variable "default_vpc_id" {
  default = "vpc-0785c748739da1093"
}


variable "vpc_id" {}