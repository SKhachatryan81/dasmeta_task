resource "helm_release" "podinfo" {
  name             = "podinfo"
  namespace        = var.namespace
  create_namespace = true
  chart            = "${path.module}/../../k8s/charts/podinfo"

  set = [{
    name  = "ingress.host"
    value = "podinfo.${data.terraform_remote_state.infra.outputs.ingress_ip}.sslip.io"
  }]

  depends_on = [helm_release.nginx_ingress, helm_release.kube_prometheus_stack]
}