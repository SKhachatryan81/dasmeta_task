terraform {
  required_version = ">= 1.6"

  backend "gcs" {
    bucket = "dasmeta-test"
    prefix = "platform/gcp"
  }

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
  }
}

provider "helm" {
  kubernetes = {
    config_path    = var.kubeconfig_path
    config_context = var.kube_context
  }
}
