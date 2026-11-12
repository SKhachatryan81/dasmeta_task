resource "google_compute_network" "main" {
  name                    = local.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "main" {
  name                     = local.subnet_name
  region                   = var.region
  network                  = google_compute_network.main.id
  ip_cidr_range            = var.ip_cidr_range
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = var.secondary_range_pods
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = var.secondary_range_services
  }
}

resource "google_compute_router" "main" {
  name    = local.router_name
  region  = var.region
  network = google_compute_network.main.id
}

resource "google_compute_router_nat" "main" {
  name                               = local.nat_name
  router                             = google_compute_router.main.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "google_compute_address" "ingress" {
  name   = local.ingress_name
  region = var.region
}
