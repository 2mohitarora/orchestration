job "sample-api" {

  group "sample-api" {
    count = 3
    
    network {
      mode = "bridge"
      port "http" {
        to = "9090"
      }
    }

    service {
      name = "sample-api"
      port = "http"

      connect {
        sidecar_service {
          proxy {}
        }
      }
    }

    task "sample-api" {
      driver = "docker"

      config {
        image = "hashicorp/http-echo:latest"

        args = [
          "-listen",
          ":9090",
          "-text",
          "Sample API behind API Gateway!",
        ]
      }
    }
  }
}