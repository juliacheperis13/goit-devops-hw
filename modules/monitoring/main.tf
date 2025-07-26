resource "helm_release" "prometheus" {
  name             = "prometheus"
  namespace        = "monitoring"
  create_namespace = true
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus"
  version          = "25.21.0"

  values = [file("${path.module}/values/prometheus-values.yaml")]
  # depends_on = [var.module_eks]
}

resource "helm_release" "grafana" {
  name             = "grafana"
  namespace        = "monitoring"
  create_namespace = false
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  version          = "7.3.0"

  values = [file("${path.module}/values/grafana-values.yaml")]

  depends_on = [helm_release.prometheus]
}

data "kubernetes_service" "grafana" {
  metadata {
    name      = "grafana"
    namespace = "monitoring"
  }

  depends_on = [helm_release.grafana]
}