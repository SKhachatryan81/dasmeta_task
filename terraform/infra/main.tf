module "network" {
  source = "./network"
  region = var.region
  project_name = var.project_name
}

module "compute" {
  source              = "./compute"
  depends_on          = [module.network]
  project_name = var.project_id
  zone                = var.zone
  network_id          = module.network.network_id
  subnetwork_id       = module.network.subnetwork_id
  pods_range_name     = module.network.pods_range_name
  services_range_name = module.network.services_range_name
}
