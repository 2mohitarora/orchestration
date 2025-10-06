job "pytechco-web" {
  type = "service"

  group "ptc-web" {
    count = 2
    network {
      port "web" {
        static = 5000
      }
    }

    service {
      name     = "web-svc"
      port     = "web"
      tags = ["python", "web"]
      provider = "consul"
      
      check {
        type     = "http"
        path     = "/"
        interval = "2s"
        timeout  = "2s"
      }
    }

    task "ptc-web-task" {
      # Retrieves the .Address and .Port connection values for
      # redis-svc with nomadService and saves them to env vars
      # REFRESH_INTERVAL is how often the UI refreshes in milliseconds
      template {
        data        = <<EOH
{{ range service "redis-svc" }}
REDIS_HOST={{ .Address }}
REDIS_PORT={{ .Port }}
FLASK_HOST=0.0.0.0
REFRESH_INTERVAL=500
{{ end }}
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