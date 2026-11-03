output "cluster_name" {
  value = module.compute.cluster_name
}

output "ingress_ip" {
  value = module.network.ingress_ip
}
