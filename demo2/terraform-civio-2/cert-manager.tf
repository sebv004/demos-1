resource "kubernetes_namespace" "certmanager" {
    
    depends_on = [
        time_sleep.wait_for_kubernetes
    ]

    metadata {
        name = "certmanager"
    }
}

resource "helm_release" "certmanager" {

  depends_on = [
    kubernetes_namespace.certmanager
  ]
  name       = "certmanager"

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace = "certmanager"

  set {
    name  = "installCRDs"
    value = "true"
  }

}

