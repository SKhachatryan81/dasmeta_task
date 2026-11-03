variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "zone" {
  type = string

  validation {
    condition     = startswith(var.zone, "${var.region}-")
    error_message = "zone must be in the selected region (e.g. europe-west1-b for europe-west1)."
  }
}
