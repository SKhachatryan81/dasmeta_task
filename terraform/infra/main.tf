module "network" {
  source = "./network"
  region = var.region
}

module "compute" {
  source              = "./compute"
  depends_on          = [module.network]
  zone                = var.zone
  network_id          = module.network.network_id
  subnetwork_id       = module.network.subnetwork_id
  pods_range_name     = module.network.pods_range_name
  services_range_name = module.network.services_range_name
}
