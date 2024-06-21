variable "consul_image" {
  type        = string
  default     = "hashicorp/consul:1.17.3"
}

variable "envoy_image" {
  type        = string
  default     = "hashicorp/envoy:1.27.3"
}

variable "api_gateway_name" {
  description = "The name of the API Gateway in Consul"
  type        = string
  default     = "api-gateway"
}

job "api-gateway" {

  type = "system"
  node_pool = "gateway"  

  group "api-gateway" {
    network {
      mode = "bridge"
      port "http" {
        static = 8443
        to     = 8443
      }
    }

    task "api-gateway-setup" {
      driver = "docker"
      config {
        image = var.consul_image # image containing Consul
        command = "/bin/sh"
        args = [
          "-c",
          "consul connect envoy -gateway api -register -deregister-after-critical 10s -service ${var.api_gateway_name} -admin-bind 0.0.0.0:19000 -ignore-envoy-compatibility -bootstrap > ${NOMAD_ALLOC_DIR}/envoy_bootstrap.json"
        ]
      }

      lifecycle {
        hook = "prestart"
        sidecar = false
      }

      env {
        CONSUL_HTTP_ADDR = "http://${attr.unique.network.ip-address}:8500"
        CONSUL_GRPC_ADDR = "${attr.unique.network.ip-address}:8502" # xDS port (non-TLS)
      }      
      
    }

    task "api-gateway" {
      driver = "docker"

      config {
        image = var.envoy_image # image containing Envoy
        args = [
          "--config-path",
          "${NOMAD_ALLOC_DIR}/envoy_bootstrap.json",
          "--log-level",
          "${meta.connect.log_level}",
          "--concurrency",
          "${meta.connect.proxy_concurrency}",
          "--disable-hot-restart"
        ]
      }
    }
  }
}