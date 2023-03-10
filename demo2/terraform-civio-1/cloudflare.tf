resource "cloudflare_record" "clcreative-main-cluster" {
    zone_id = "fc219da62d15f73fb9cdfbb0fe782303"
    name = "demo-2.sebv004.com"
    value =  data.civo_loadbalancer.traefik_lb.public_ip
    type = "A"
    proxied = false
}