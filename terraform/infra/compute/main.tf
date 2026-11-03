resource "google_container_cluster" "main" {
  name     = "dasmeta"
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

  # No default node pool; nodes come from google_container_node_pool.spot
  initial_node_count  = 0
  deletion_protection = false
}

resource "google_container_node_pool" "spot" {
  name       = "spot-pool"
  cluster    = google_container_cluster.main.name
  location   = var.zone
  node_count = 2

  node_config {
    spot         = true
    machine_type = "e2-medium"
    disk_size_gb = 30
    disk_type    = "pd-standard"
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}
