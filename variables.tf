variable "env" {}

variable "tags"{
  default = {}
}
variable "vpc" {}
variable "default_vpc_id" {}
variable "default_route_id" {}
variable "rabbitmq" {}
variable "allow_ssh_cidr" {}
variable "zone_id" {}
variable "rds" {}
variable "kms_id" {}
variable "kms_key_arn" {}
variable "elasticache" {}
variable "documentdb" {}
variable "alb" {}
variable "apps" {}
variable "allow_prometheus_cidr" {}


