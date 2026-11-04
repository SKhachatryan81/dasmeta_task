# Public DNS name for the ingress IP; sslip.io resolves <ip>.sslip.io to <ip>
locals {
  base_domain = "${module.network.ingress_ip}.sslip.io"
}

output "cluster_name" {
  value = module.compute.cluster_name
}

output "ingress_ip" {
  value = module.network.ingress_ip
}

output "base_domain" {
  value = local.base_domain
}

output "podinfo_url" {
  value = "http://podinfo.${local.base_domain}"
}

output "grafana_url" {
  value = "http://grafana.${local.base_domain}"
}
