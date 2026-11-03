# Metrics (Prometheus) + dashboards (Grafana)
resource "helm_release" "kube_prometheus_stack" {
  name             = "kube-prometheus-stack"
  namespace        = "monitoring"
  create_namespace = true

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = var.kube_prometheus_stack_chart_version

  values = [file("${path.module}/values/kube-prometheus-stack.yaml")]

  set = [{
    name  = "grafana.ingress.hosts[0]"
    value = "grafana.${data.terraform_remote_state.infra.outputs.ingress_ip}.sslip.io"
  }]

  timeout    = 600
  depends_on = [helm_release.nginx_ingress]
}

# Log storage
resource "helm_release" "loki" {
  name             = "loki"
  namespace        = "monitoring"
  create_namespace = true

  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki"
  version    = var.loki_chart_version

  values = [file("${path.module}/values/loki.yaml")]

  timeout = 600
}

# Log collector: tails pod logs and ships them to Loki
resource "helm_release" "alloy" {
  name             = "alloy"
  namespace        = "monitoring"
  create_namespace = true

  repository = "https://grafana.github.io/helm-charts"
  chart      = "alloy"
  version    = var.alloy_chart_version

  values = [file("${path.module}/values/alloy.yaml")]

  depends_on = [helm_release.loki]
}
