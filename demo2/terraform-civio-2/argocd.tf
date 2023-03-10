resource "kubernetes_namespace" "argocd" {
    
    depends_on = [
        time_sleep.wait_for_kubernetes
    ]

    metadata {
        name = "argocd"
    }
}

resource "helm_release" "argocd" {

  depends_on = [
    kubernetes_namespace.argocd
  ]
  name       = "argocd"

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace = "argocd"

}

