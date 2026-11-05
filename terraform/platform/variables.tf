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

variable "namespace" {
  type    = string
  default = "dev"
}
variable "kube_prometheus_stack_chart_version" {
  type = string
}

variable "loki_chart_version" {
  type = string
}

variable "alloy_chart_version" {
  type = string
}

variable "slack_webhook_url" {
  type      = string
  sensitive = true
}