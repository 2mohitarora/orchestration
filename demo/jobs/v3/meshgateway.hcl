job "mesh-gateway" {
  
  # enable_mesh_gateway_wan_federation (only on servers?)
  # Ensure the primary datacenter has at least one running, registered mesh gateway with the service metadata key of {"consul-wan-federation":"1"} set.
  # primary_datacenter (Everywhere)
  # mesh="local"
  # primary_gateways
  # https://developer.hashicorp.com/consul/tutorials/developer-mesh/service-mesh-gateways
  # https://developer.hashicorp.com/consul/docs/connect/gateways/mesh-gateway/wan-federation-via-mesh-gateways
  # https://developer.hashicorp.com/consul/docs/connect/gateways/mesh-gateway/service-to-service-traffic-wan-datacenters
  # Another useful example of leveraging a service-resolver configuration would be to expose services in the local Consul Datacenter, but redirect them to a given service in a remote federated Consul Datacenter:
  #This example will redirect all traffic destined for service “web-dc2” in the local Consul Datacenter to the service “web” in the remote Consul Datacenter “dc2.”
    # kind = “service-resolver”
    # name = “web-dc2”
    # redirect {
    # service = “web”
    # data center = “dc2”
    #}


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