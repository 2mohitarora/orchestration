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
      tags = ["nginx", "ilb"]
      meta {
        metrics_port_envoy = "${NOMAD_HOST_PORT_metrics_envoy}"
      }
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
  server {{ env "NOMAD_UPSTREAM_IP_web_svc"}}:{{ env "NOMAD_UPSTREAM_PORT_web_svc"}};
}

upstream java-backend {
  server {{ env "NOMAD_UPSTREAM_IP_java_web_svc"}}:{{ env "NOMAD_UPSTREAM_PORT_java_web_svc"}};
}

server {
   listen 8080;
   server_name  localhost;
   server_tokens off;
   gzip on;
   gzip_proxied any;
   gzip_comp_level 4;
   gzip_types text/css application/javascript image/svg+xml;
   proxy_http_version 1.1;
   proxy_set_header Upgrade $http_upgrade;
   proxy_set_header Connection 'upgrade';
   proxy_set_header Host $host;
   proxy_cache_bypass $http_upgrade;
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
