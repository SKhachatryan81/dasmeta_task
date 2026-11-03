terraform {
  required_version = ">= 1.9"

  backend "gcs" {
    bucket = "dasmeta-test"
    prefix = "infra/gcp"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 8.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}
