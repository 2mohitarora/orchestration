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
    }

    service {
      name = "ingress-gateway"
      port = "inbound"
      tags = ["ingress-gateway", "t2"]

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
            }
          }
        }
      }
    }
  }
}  