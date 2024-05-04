job "terminating-gateway" {
  
  type = "system"
  node_pool = "gateway"  
  
  group "terminating-gateway" {
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
              name = "httpforever-svc"
            }
          }
        }
      }
    }
  }
}  