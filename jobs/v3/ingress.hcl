job "ingress-gateway" {
  
  type = "system"
  node_pool = "gateway"  
  
  group "ingress-gateway" {
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
              service {
                name = "httpforever-client-svc"
                hosts = ["httpforeverclient.com"]
              }
            }
          }
        }
      }
    }
  }
}  