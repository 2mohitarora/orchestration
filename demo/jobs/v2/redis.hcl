job "pytechco-redis" {
  type = "service"

  group "ptc-redis" {
    count = 1
    network {
      mode = "bridge"
      port "redis" {
        to = 6379
      }
    }

    service {
      name     = "redis-svc"
      tags = ["redis"]
      port     = 6379
      provider = "consul"
      connect {
        sidecar_service {
          proxy {
            
          }
        }
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