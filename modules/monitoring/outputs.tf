# output "grafana_nodeport" {
#   description = "Grafana NodePort"
#   value       = data.kubernetes_service.grafana.spec.ports[0].node_port
# }


# output "grafana_url" {
#   description = "Grafana UI URL"
#   value       = "http://localhost:${data.kubernetes_service.grafana.spec.ports[0].node_port}"
# }

output "grafana_service_debug" {
  value = data.kubernetes_service.grafana
}


output "prometheus_service_url" {
  description = "Prometheus ClusterIP URL"
  value       = "http://prometheus-server.monitoring.svc.cluster.local"
}

output "grafana_admin_credentials" {
  description = "Grafana admin login credentials"
  value = {
    username = "admin"
    password = "admin123"
  }
  sensitive = true
}

output "imported_dashboards" {
  description = "Grafana dashboards imported by default"
  value = [
    {
      name   = "Node Exporter Full"
      gnetId = 1860
    },
    {
      name   = "Kubernetes Cluster"
      gnetId = 315
    },
    {
      name   = "Prometheus Stats"
      gnetId = 3662
    }
  ]
}
