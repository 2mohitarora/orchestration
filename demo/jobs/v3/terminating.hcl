job "terminating-gateway" {
  
  type = "service"
  node_pool = "ingress-gateway"  
  
  group "terminating-gateway" {
    count = 3
    network {
      mode = "bridge"
      port "egress" {
        static = 8082
      }
    }

    service {
      name = "terminating-gateway"
      port = "egress"
      tags = ["terminating-gateway"]

      #Explore Envoy PassiveHealthCheck - how they can be added

      connect {
        gateway {
          proxy {
	          connect_timeout = "500ms"
	        }  
          terminating {
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
            }
          }
        }
      }
    }
  }
}  