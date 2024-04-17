job "egress-client" {

  type = "service"
  node_pool = "java"

  group "egress-client" {
    count = 1
    network {
      mode = "bridge"
      port "http" {
        static = 8080
      }
      port "metrics_envoy" {
        to = 9102
      }
    }

    service {
      name     = "egress-svc"
      port     = "http"
      provider = "consul"
      tags = ["web", "egress-client"]
      meta {
        metrics_port_envoy = "${NOMAD_HOST_PORT_metrics_envoy}"
      }
      check {
        type     = "http"
        path     = "/check"
        interval = "60s"
        timeout  = "1s"
      }

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "google-svc"
              local_bind_port  = 8081
            }
          }
        }
      }
    }

    task "egress-client" {
      template {
        data = <<EOH
WEBSITE=http://{{ env "NOMAD_UPSTREAM_IP_google_svc"}}:{{ env "NOMAD_UPSTREAM_PORT_google_svc"}}
EOH
        destination = "local/env.txt"
        env = true
      }
        
      driver = "java"
      artifact {
        source      = "https://docs.google.com/uc?export=download&id=1U2fMVxVLh8BT6xfal748omzHwut02gZJ"
        mode = "file"
        destination = "local/spring-boot-send-email-1.0.jar"
      }
      
      config {
        jar_path    = "local/spring-boot-send-email-1.0.jar"
        jvm_options = ["-Xmx128m", "-Xms64m"]
      }
    }
  }
}