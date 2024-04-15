job "terminating-gateway" {
  
  type = "service"
  node_pool = "ingress-gateway"  
  
  group "terminating-gateway" {
    count = 3
    network {
      mode = "bridge"
    }

    service {
      name = "terminating-gateway"
      tags = ["terminating-gateway"]

      #Explore Envoy PassiveHealthCheck - how they can be added

      connect {
        gateway {
          proxy {
	          connect_timeout = "500ms"
	        }  
          terminating {
            service {
              name = "google-svc"
            }
          }
        }
      }
    }
  }
}  