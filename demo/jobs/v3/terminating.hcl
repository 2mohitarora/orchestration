job "terminating-gateway" {
  
  type = "service"
  node_pool = "ingress-gateway"  
  
  group "terminating-gateway" {
    count = 3
    network {
      mode = "bridge"
      port "metrics_envoy" {
        to = 9102
      }
    }

    service {
      name = "terminating-gateway"
      tags = ["terminating-gateway"]
      meta {
        metrics_port_envoy = "${NOMAD_HOST_PORT_metrics_envoy}"
      }
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