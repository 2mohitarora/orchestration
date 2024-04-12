job "pytechco-web" {
  type = "service"

  group "ptc-web" {
    count = 3
    network {
      mode = "bridge"
      port "web" {
        static = 5000
      }
    }

    service {
      name     = "web-svc"
      tags = ["python", "web"]
      port     = 5000
      provider = "consul"
      
      check {
        type     = "http"
        path     = "/"
        interval = "2s"
        timeout  = "2s"
      }
      connect {
        sidecar_service {
          proxy {
            config {
               protocol = "http"
             }
            upstreams {
              destination_name = "redis-svc"
              local_bind_port  = 6379
            }
          }
        }
      }
    }

    task "ptc-web-task" {
      template {
        data        = <<EOH
FLASK_HOST=0.0.0.0
REFRESH_INTERVAL=500
{{ range tree "config/web-svc" }}
{{ .Key }}={{ .Value }}
{{ end }}
EOH
        destination = "local/env.txt"
        env         = true
      }

      driver = "docker"

      config {
        image = "ghcr.io/hashicorp-education/learn-nomad-getting-started/ptc-web:1.0"
        ports = ["web"]
      }
      env {
        REDIS_HOST="${NOMAD_UPSTREAM_IP_redis_svc}"
        REDIS_PORT="${NOMAD_UPSTREAM_PORT_redis_svc}"
      }
    }
  }
}