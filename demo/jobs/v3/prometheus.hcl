job "prometheus" {
  type        = "service"

  group "monitoring" {
    count = 1
    network {
      mode = "bridge"
      port "prometheus_ui" {
        static = 9090
      }
    }
    restart {
      attempts = 2
      interval = "30m"
      delay    = "15s"
      mode     = "fail"
    }

    ephemeral_disk {
      size = 300
    }

    task "prometheus" {
      template {
        change_mode = "noop"
        destination = "local/prometheus.yml"

        data = <<EOH
---
global:
  scrape_interval:     1m
  evaluation_interval: 1m
scrape_configs:
  - job_name: 'consul-connect-envoy'
    consul_sd_configs:
    - server: '{{ env "NOMAD_IP_prometheus_ui" }}:8500'
    relabel_configs:
    - source_labels: [__meta_consul_service_metadata_metrics_port_envoy]
      regex: (.+)
      action: keep
    - source_labels: [__address__,__meta_consul_service_metadata_metrics_port_envoy]
      separator: "@"
      regex: (^.*):(.*)@(.*)
      replacement: $1:$3
      target_label: __address__
      action: replace
EOH
      }

      driver = "docker"
      config {
        image = "prom/prometheus:latest"
        volumes = [
          "local/prometheus.yml:/etc/prometheus/prometheus.yml",
        ]
        ports = ["prometheus_ui"]
      }

      service {
        name = "prometheus"
        tags = ["prometheus"]
        port = "prometheus_ui"
        check {
          name     = "prometheus_ui port alive"
          type     = "http"
          path     = "/-/healthy"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}