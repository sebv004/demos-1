resource "kubernetes_namespace" "beacon" {
    
    depends_on = [
        time_sleep.wait_for_kubernetes
    ]

    metadata {
        name = "beacon"
    }
}

variable "datadog_api_key" {
    type = string
}

resource "helm_release" "datadog_agent" {

      depends_on = [
    helm_release.istio_ingress
  ]

  name       = "datadog-agent"
  chart      = "datadog"
  repository = "https://helm.datadoghq.com"
  version    = "3.11.0"
  namespace  = "beacon"

  set_sensitive {
    name  = "datadog.apiKey"
    value = var.datadog_api_key
  }

  set_sensitive {
    name  = "targetSystem"
    value = "linux"
  }

  set_sensitive {
    name  = "datadog.site"
    value = "datadoghq.eu"
  }


  set {
    name  = "datadog.logs.enabled"
    value = true
  }

  set {
    name  = "datadog.logs.containerCollectAll"
    value = true
  }

  set {
    name  = "datadog.leaderElection"
    value = true
  }

  set {
    name  = "datadog.collectEvents"
    value = true
  }

  set {
    name  = "clusterAgent.enabled"
    value = true
  }

  set {
    name  = "clusterAgent.metricsProvider.enabled"
    value = true
  }

  set {
    name  = "networkMonitoring.enabled"
    value = true
  }

  set {
    name  = "systemProbe.enableTCPQueueLength"
    value = true
  }

  set {
    name  = "systemProbe.enableOOMKill"
    value = true
  }

  set {
    name  = "securityAgent.runtime.enabled"
    value = true
  }

  set {
    name  = "datadog.hostVolumeMountPropagation"
    value = "HostToContainer"
  }
}
