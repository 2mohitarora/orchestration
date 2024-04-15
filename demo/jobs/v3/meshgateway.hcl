job "mesh-gateway" {
  
  type = "service"
  node_pool = "ingress-gateway"  
  
  group "mesh-gateway" {
    count = 3
    network {
      mode = "bridge"
      port "mesh_wan" {
        # A mesh gateway will require a host_network configured for at least one
        # Nomad client that can establish cross-datacenter connections. Nomad will
        # automatically schedule the mesh gateway task on compatible Nomad clients.
        host_network = "public"
      }
    }

    service {
      name = "mesh-gateway"
      port = "mesh_wan"
      tags = ["mesh-gateway"]

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