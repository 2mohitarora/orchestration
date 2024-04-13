job "nginx" {

  group "nginx" {
    count = 1

    network {
      mode = "bridge"
      port "http" {
        static = 8080
      }
    }

    service {
      name = "nginx"
      port = "http"
      tags = ["nginx", "lb"]
      check {
        type     = "http"
        path     = "/"
        interval = "2s"
        timeout  = "2s"
      }
      check {
        type     = "http"
        path     = "/actuator/health"
        interval = "2s"
        timeout  = "2s"
      }
      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "web-svc"
              local_bind_port  = 5000
            }
            upstreams {
              destination_name = "java-web-svc"
              local_bind_port  = 9090
            }
          }
        }
      }
    }

    task "nginx" {
      driver = "docker"
      config {
        image = "nginx"
        ports = ["http"]
        volumes = [
          "local:/etc/nginx/conf.d",
        ]
      }

      template {
        data = <<EOF
upstream backend {
{{ range service "web-svc" }}
  server {{ .Address }}:{{ .Port }};
{{ else }}server 127.0.0.1:65535; # force a 502
{{ end }}
}

upstream java-backend {
{{ range service "java-web-svc" }}
  server {{ .Address }}:{{ .Port }};
{{ else }}server 127.0.0.1:65535; # force a 502
{{ end }}
}

server {
   listen 8080;
   location /actuator/health {
      proxy_pass http://java-backend;
   }
   location / {
      proxy_pass http://backend;
   }
}
EOF

        destination   = "local/load-balancer.conf"
        change_mode   = "signal"
        change_signal = "SIGHUP"
      }
    }
  }
}
