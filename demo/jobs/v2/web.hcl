job "pytechco-web" {
  type = "service"

  group "ptc-web" {
    count = 3
    network {
      mode = "bridge"
      port "web" {
      }
      port "metrics_envoy" {
        to = 9102
      }
    }

    service {
      name     = "web-svc"
      tags = ["python", "web"]
      port     = "web"
      provider = "consul"
      meta {
        metrics_port_envoy = "${NOMAD_HOST_PORT_metrics_envoy}"
      }
      check {
        type     = "http"
        path     = "/"
        interval = "2s"
        timeout  = "2s"
      }
      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "redis-svc"
              local_bind_port  = 6379
            }
          }
        }
      }
    }

    task "ptc-web-task" {
      env {
        FLASK_HOST="0.0.0.0"
        FLASK_PORT="${NOMAD_PORT_web}"
        REDIS_HOST="${NOMAD_UPSTREAM_IP_redis_svc}"
        REDIS_PORT="${NOMAD_UPSTREAM_PORT_redis_svc}"
      }
      template {
        data        = <<EOH
DEBUG_REDIS_DETAILS={{ env "NOMAD_UPSTREAM_IP_redis_svc"}}:{{ env "NOMAD_UPSTREAM_PORT_redis_svc"}}
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
    }
  }
}