job "mesh-gateway" {
  
  type = "service"
  node_pool = "ingress-gateway"  
  
  group "mesh-gateway" {
    count = 3
    network {
      mode = "bridge"
      port "mesh_wan" {}
    }

    service {
      name = "mesh-gateway"
      port = "mesh_wan"
      tags = ["mesh-gateway"]
      meta {
          consul-wan-federation = "1"
      }
      connect {
        gateway {
          proxy {
	          connect_timeout = "500ms"
	        }  
          mesh {
          }
        }
      }
    }
  }
}  