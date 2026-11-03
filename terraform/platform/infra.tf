# Outputs of terraform/infra (cluster name, static ingress IP)
data "terraform_remote_state" "infra" {
  backend = "gcs"

  config = {
    bucket = "dasmeta-test"
    prefix = "infra/gcp"
  }
}
