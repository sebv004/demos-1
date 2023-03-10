resource "kubernetes_namespace" "istio-system" {
    
    depends_on = [
        time_sleep.wait_for_kubernetes
    ]

    metadata {
        name = "istio-system"
    }
}

resource "helm_release" "istiobase" {

  depends_on = [
    kubernetes_namespace.istio-system
  ]
  name       = "istiobase"

  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "base"
  namespace = "istio-system"

}

resource "helm_release" "istiod" {

  depends_on = [
    helm_release.istiobase
  ]
  name       = "istiod"

  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  namespace = "istio-system"

}

resource "helm_release" "istio_ingress" {
  name  = "istio-ingress"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart = "gateway"

  timeout = 500
  cleanup_on_fail = true
  force_update    = false
  namespace       = kubernetes_namespace.istio-system.metadata.0.name

  depends_on = [ helm_release.istiod]
}