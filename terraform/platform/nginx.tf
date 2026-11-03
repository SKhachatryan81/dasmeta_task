resource "helm_release" "nginx_ingress" {
  name             = "nginx-ingress"
  namespace        = "ingress-nginx"
  create_namespace = true

  repository = "oci://ghcr.io/nginx/charts"
  chart      = "nginx-ingress"
  version    = var.nginx_chart_version

  values = [yamlencode({
    controller = {
      ingressClass = {
        name = "nginx"
      }
      service = {
        type        = "LoadBalancer"
        annotations = var.nginx_service_annotations
      }
    }
  })]

  wait    = true
  timeout = 300
}