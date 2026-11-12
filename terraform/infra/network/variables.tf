variable "region" {
  type = string
}
variable "project_name" {
  type = string
}
variable "vpc_name" {
  type = string
  default = null
}
variable "subnet_name" {
  type = string
  default = null
}
variable "ip_cidr_range" {
  type = string
  default = "10.10.0.0/24"
}
variable "secondary_range_pods" {
  type = string
  default = "10.20.0.0/16"
}
variable "secondary_range_services" {
  type = string
  default = "10.30.0.0/20"
}
variable "router_name" {
  type = string
  default = null
}
variable "nat_name" {
  type = string
  default = null
}
variable "ingress_name" {
  type = string
  default = null
}
locals {
  vpc_name = coalesce(var.vpc_name, "${var.project_name}-vpc")
  subnet_name = coalesce(var.subnet_name, "${var.project_name}-subnet")
  router_name = coalesce(var.router_name, "${var.project_name}-router")
  nat_name = coalesce(var.nat_name, "${var.project_name}-nat")
  ingress_name = coalesce(var.ingress_name, "${var.project_name}-ingress")
}