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
        type           = "LoadBalancer"
        loadBalancerIP = data.terraform_remote_state.infra.outputs.ingress_ip
      }
    }
  })]

  wait    = true
  timeout = 300
}
