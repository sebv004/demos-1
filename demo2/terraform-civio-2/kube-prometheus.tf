resource "kubernetes_namespace" "monitoring" {
    
    depends_on = [
        time_sleep.wait_for_kubernetes
    ]

    metadata {
        name = "monitoring"
    }
}

resource "helm_release" "kube-prom" {

  depends_on = [
    kubernetes_namespace.monitoring
  ]
  name       = "kube-prometheus-stack"

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace = "monitoring"

  set {
        name  = "prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues"
        value = "false"
    }
    set {
        name  = "fullnameOverride"
        value = "prometheus"
    }

}

