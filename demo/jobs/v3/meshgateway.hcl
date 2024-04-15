job "mesh-gateway" {
  
  # enable_mesh_gateway_wan_federation (only on servers?)
  # Ensure the primary datacenter has at least one running, registered mesh gateway with the service metadata key of {"consul-wan-federation":"1"} set.
  # primary_datacenter (Everywhere)
  # mesh="local"
  # primary_gateways
  # https://developer.hashicorp.com/consul/tutorials/developer-mesh/service-mesh-gateways
  # https://developer.hashicorp.com/consul/docs/connect/gateways/mesh-gateway/wan-federation-via-mesh-gateways
  # https://developer.hashicorp.com/consul/docs/connect/gateways/mesh-gateway/service-to-service-traffic-wan-datacenters
   

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