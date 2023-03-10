data "civo_size" "xsmall" {
    filter {
        key = "name"
        values = ["g4s.kube.medium"]
        match_by = "re"
    }
}


    # Create a firewall
resource "civo_firewall" "my-firewall" {
    name = "my-firewall-small"
    create_default_rules = false
    ingress_rule {
    label = "kubernetes-api-server"
    protocol   = "tcp"
    port_range = "6443"
    cidr = ["78.129.68.198/32","212.222.125.68/32","82.212.165.142/32"]
    action     = "allow"
  }
  ingress_rule {
    label = "nginx-http"
    protocol   = "tcp"
    port_range = "80"
    cidr = ["0.0.0.0/0"]
    action     = "allow"
  }
  ingress_rule {
    label = "nginx-https"
    protocol   = "tcp"
    port_range = "443"
    cidr = ["0.0.0.0/0"]
    action     = "allow"
  }
}



# Create a cluster
resource "civo_kubernetes_cluster" "my-cluster-1" {
    depends_on = [
      civo_firewall.my-firewall
    ]
    name = "my-cluster-small"
    applications = ""
    firewall_id = civo_firewall.my-firewall.id
    pools {
        label = "my-cluster-1-node" // Optional
        size = element(data.civo_size.xsmall.sizes, 0).name
        node_count = 2
    }
}

resource "local_file" "mykubeconfig" {
  depends_on = [
        time_sleep.wait_for_kubernetes
    ]
  content = civo_kubernetes_cluster.my-cluster-1.kubeconfig
  filename = "/mnt/c/Users/svil/.kube/config"
}

resource "time_sleep" "wait_for_kubernetes" {

    depends_on = [
        civo_kubernetes_cluster.my-cluster-1
    ]

    create_duration = "30s"
}

data "civo_loadbalancer" "traefik_lb" {

    depends_on = [
        helm_release.traefik
    ]

    name = "my-cluster-small-traefik-traefik"
}