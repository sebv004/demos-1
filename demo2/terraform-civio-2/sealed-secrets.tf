data "kubectl_filename_list" "sealed" {
    pattern = "./secret-sealed-main.yaml"
}

resource "kubectl_manifest" "sealed" {
  depends_on = [
        time_sleep.wait_for_kubernetes
    ]
    count     = length(data.kubectl_filename_list.sealed.matches)
    yaml_body = file(element(data.kubectl_filename_list.sealed.matches, count.index))
}

resource "helm_release" "sealed-secrets" {

  depends_on = [
    kubectl_manifest.sealed
  ]
  name       = "sealed-secrets"

  repository = "https://bitnami-labs.github.io/sealed-secrets"
  chart      = "sealed-secrets"
  namespace = "kube-system"

}