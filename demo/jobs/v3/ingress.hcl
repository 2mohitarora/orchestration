job "ingress-gateway" {
  
  type = "service"
  node_pool = "ingress-gateway"  
  
  group "ingress-gateway" {
    count = 3
    network {
      mode = "bridge"
      port "inbound" {
        static = 8080
      }
      port "metrics_envoy" {
        to = 9102
      }
    }

    service {
      name = "ingress-gateway"
      port = "inbound"
      tags = ["ingress-gateway", "t2"]
      meta {
        metrics_port_envoy = "${NOMAD_HOST_PORT_metrics_envoy}"
      }
      #Explore Envoy PassiveHealthCheck - how they can be added

      connect {
        gateway {
          proxy {
	          connect_timeout = "500ms"
	        }  
          ingress {
            listener {
              port     = 8080
              protocol = "http"
              service {
                name = "web-svc"
                hosts = ["websvc.com"]
              }
              service {
                name = "java-web-svc"
                hosts = ["javasvc.com"]
              }
              service {
                name = "egress-svc"
                hosts = ["egress.com"]
              }
            }
          }
        }
      }
    }
  }
}  