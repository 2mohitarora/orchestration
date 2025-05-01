job "java-web" {

  type = "service"
  node_pool = "java"

  group "java-web" {
    count = 1
    network {
      mode = "bridge"
      port "http" {
      }
      port "metrics_envoy" {
        to = 9102
      }
    }

    service {
      name     = "java-web-svc"
      port     = "http"
      provider = "consul"
      tags = ["java", "web"]
      meta {
        metrics_port_envoy = "${NOMAD_HOST_PORT_metrics_envoy}"
      }
      check {
        type     = "http"
        path     = "/actuator/health"
        interval = "2s"
        timeout  = "1s"
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

    task "java-web" {
      env {
        SERVER_PORT = "${NOMAD_PORT_http}"
        SPRING_DATA_REDIS_HOST = "${NOMAD_UPSTREAM_IP_redis_svc}"
        SPRING_DATA_REDIS_PORT = "${NOMAD_UPSTREAM_PORT_redis_svc}"
      }
      template {
        data = <<EOH
DEBUG_REDIS_DETAILS={{ env "NOMAD_UPSTREAM_IP_redis_svc"}}:{{ env "NOMAD_UPSTREAM_PORT_redis_svc"}}
{{ range tree "config/java-web-svc" }}
{{ .Key }}={{ .Value }}
{{ end }}
EOH
        destination = "local/env.txt"
        env = true
      }
        
      driver = "java"
      artifact {
        source      = "https://github.com/2mohitarora/test/raw/refs/heads/main/urlshortener-0.0.1-SNAPSHOT.jar"
        mode = "file"
        destination = "local/urlshortener-0.0.1-SNAPSHOT.jar"
      }
      
      config {
        jar_path    = "local/urlshortener-0.0.1-SNAPSHOT.jar"
        jvm_options = ["-Xmx128m", "-Xms64m"]
      }
    }
  }
}