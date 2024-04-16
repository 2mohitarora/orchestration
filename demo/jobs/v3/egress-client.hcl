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
    }

    service {
      name     = "egress-svc"
      port     = "http"
      provider = "consul"
      tags = ["web", "egress-client"]
      
      check {
        type     = "http"
        path     = "/"
        interval = "2s"
        timeout  = "1s"
      }

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "google-svc"
              local_bind_port  = 8080
            }
          }
        }
      }
    }

    task "egress-client" {
      template {
        data = <<EOH
GOOGLE_ADDRESS={{ env "NOMAD_UPSTREAM_IP_google_svc"}}:{{ env "NOMAD_UPSTREAM_PORT_google_svc"}}
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