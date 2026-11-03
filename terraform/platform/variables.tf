variable "kubeconfig_path" {
  type    = string
  default = "~/.kube/config"
}

variable "kube_context" {
  type = string
}

variable "nginx_chart_version" {
  type        = string
  description = "nginx/kubernetes-ingress Helm chart version (pin it)"
}

variable "nginx_service_annotations" {
  type        = map(string)
  default     = {}
  description = "Annotations for the controller's LoadBalancer Service (e.g. AWS NLB settings)"
}