variable "zone" {
  type = string
}
variable "project_name" {
  type = string
}
variable "network_id" {
  type = string
}
variable "subnetwork_id" {
  type = string
}
variable "pods_range_name" {
  type = string
}
variable "services_range_name" {
  type = string
}
variable "cluster_name" {
  type = string
  default = null
}
variable "disk_type" {
  type = string
  default = "pd-standard"
}
variable "machine_type" {
  type = string
  default = "e2-medium"
}
variable "node_count" {
  type = number
  default = 2
}
variable "is_spot" {
  type = bool
  default = true
}
variable "disk_size_gb" {
  type = number
  default = 30
}

locals {
  cluster_name = coalesce(var.cluster_name, "${var.project_name}-cluster")
}