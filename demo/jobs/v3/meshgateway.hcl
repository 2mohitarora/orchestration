job "mesh-gateway" {
  #enable_mesh_gateway_wan_federation (only on servers?)
  #primary_datacenter (Everywhere)
  #mesh="local"
  #primary_gateways

  type = "service"
  node_pool = "ingress-gateway"  
  
  group "mesh-gateway" {
    count = 3
    network {
      mode = "bridge"
      port "mesh" {
        static = 8081
      }
    }

    service {
      name = "mesh-gateway"
      port = "mesh"
      tags = ["mesh-gateway"]

      #Explore Envoy PassiveHealthCheck - how they can be added

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