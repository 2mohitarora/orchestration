job "pytechco-redis" {
  type = "service"

  group "ptc-redis" {
    count = 1
    network {
      mode = "bridge"
      port "redis" {
        to = 6379
      }
      port "metrics_envoy" {
        to = 9102
      }
    }

    service {
      name     = "redis-svc"
      tags = ["redis"]
      port     = 6379
      provider = "consul"
      meta {
        metrics_port_envoy = "${NOMAD_HOST_PORT_metrics_envoy}"
      }
      connect {
        sidecar_service {}
      }
    }

    task "redis-task" {
      driver = "docker"

      config {
        image = "redis:7.0.7-alpine"
        ports = ["redis"]
      }
    }
  }
}