output "network_id" {
  value = google_compute_network.main.id
}

output "subnetwork_id" {
  value = google_compute_subnetwork.main.id
}

output "pods_range_name" {
  value = google_compute_subnetwork.main.secondary_ip_range[0].range_name
}

output "services_range_name" {
  value = google_compute_subnetwork.main.secondary_ip_range[1].range_name
}

output "ingress_ip" {
  value = google_compute_address.ingress.address
}
