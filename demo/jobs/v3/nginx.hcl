job "nginx" {

  node_pool = "elb"

  group "nginx" {
    count = 1

    network {
      mode = "bridge"
      port "http" {
        static = 80
      }
    }

    service {
      name = "nginx"
      port = "http"
      tags = ["nginx", "elb"]
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

server {
   listen 80;
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
