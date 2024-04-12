job "ingress-gateway" {
  type = "service"
  node_pool = "ingress-gateway"  
  group "ingress-group" {
    count = 3
    network {
      mode = "bridge"
      port "inbound" {
        to     = 8080
      }
    }

    service {
      name = "ingress-gateway"
      port = "inbound"

      connect {
        gateway {
          proxy {}  
          ingress {
            listener {
              port     = 8080
              protocol = "http"
              service {
                name = "web-svc"
              }
            }
          }
        }
      }
    }
  }
}  