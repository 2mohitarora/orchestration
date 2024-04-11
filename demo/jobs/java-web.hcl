job "java-web" {

  type = "service"
  node_pool = "java"

  group "java-web" {
    count = 1
    network {
      port "http" {
        static = 9090
      }
    }

    service {
      name     = "java-web-svc"
      port     = "http"
      provider = "consul"
      tags = ["java", "web"]
      meta {
          meta = "Java service running directly on VM"
      }

      check {
        type     = "http"
        path     = "/actuator/health"
        interval = "2s"
        timeout  = "1s"
      }
    }

    task "java-web" {
      env {
        PORT    = "${NOMAD_PORT_http}"
        NODE_IP = "${NOMAD_IP_http}"
      }
      template {
        data = <<EOH
SPRING_DATA_REDIS_HOST = "{{ range service "redis-svc" }}{{ .Address }}{{ end }}"
SPRING_DATA_REDIS_PORT = "{{ range service "redis-svc" }}{{ .Port }}{{ end }}"
{{ range tree "config/java-web-svc" }}
{{ .Key }}={{ .Value }}
{{ end }}
EOH
        destination = "local/env.txt"
        env = true
      }
        
      driver = "java"
      artifact {
        source      = "https://docs.google.com/uc?export=download&id=1cSuFFZCQKYSnmo7-OUnTBSnm8MmTkxs8"
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