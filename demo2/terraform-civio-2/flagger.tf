resource "kubernetes_namespace" "flagger_system" {
    
    depends_on = [
        time_sleep.wait_for_kubernetes
    ]

    metadata {
        name = "flagger-system"
    }
}

variable "slack_url" {
    type = string
}

resource "helm_release" "flagger" {
    depends_on = [
        kubernetes_namespace.flagger_system
    ]

    name = "flagger"
    namespace = "flagger-system"

    repository = "https://flagger.app"
    chart = "flagger"


    set {
        name  = "meshProvider"
        value = "istio"
    }
    set {
        name  = "metricsServer"
        value = "http://prometheus-prometheus.monitoring:9090"
    }
    
    set {
        name  = "slack.url"
        value = "${var.slack_url}"
    }

    set {
        name  = "slack.channel"
        value = "k8s"
    }

    set {
        name  = "slack.user"
        value = "flagger"
    }
}

resource "helm_release" "flagger_loadtester" {
    depends_on = [
        helm_release.flagger
    ]

    name = "flagger-loadtester"
    namespace = "flagger-system"

    repository = "https://flagger.app"
    chart = "loadtester"
}