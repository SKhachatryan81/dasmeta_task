resource "google_container_cluster" "main" {
  name     = local.cluster_name
  location = var.zone

  network    = var.network_id
  subnetwork = var.subnetwork_id

  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_range_name
    services_secondary_range_name = var.services_range_name
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
  }

  initial_node_count  = 0
  deletion_protection = false
}

resource "google_container_node_pool" "spot" {
  name       = "spot-pool"
  cluster    = google_container_cluster.main.name
  location   = var.zone
  node_count = var.node_count

  node_config {
    spot         = var.is_spot
    machine_type = var.machine_type
    disk_size_gb = var.disk_size_gb
    disk_type    = var.disk_type
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}
