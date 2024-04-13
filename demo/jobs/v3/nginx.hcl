job "nginx-elb" {

  node_pool = "elb"
  group "nginx-elb" {
    count = 1

    network {
      mode = "bridge"
      port "http" {
        static = 80
      }
    }

    service {
      name = "nginx-elb"
      port = "http"
      tags = ["nginx", "elb"]
    }

    task "nginx-elb" {
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
{{ range service "ingress-gateway" }}
  server {{ .Address }}:{{ .Port }};
{{ else }}server 127.0.0.1:65535; # force a 502
{{ end }}

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
