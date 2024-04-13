job "ingress-gateway" {
  
  type = "service"
  node_pool = "ingress-gateway"  
  
  group "ingress-gateway" {
    count = 3
    network {
      mode = "bridge"
      port "inbound" {
        static = 8080
        to     = 8080
      }
    }

    service {
      name = "ingress-gateway"
      port = "inbound"
      tags = ["ingress-gateway", "t2"]

      #check {
      #  type     = "http"
      #  path     = "/"
      #  interval = "2s"
      #  timeout  = "2s"
      #}

      connect {
        gateway {
          proxy {
	          connect_timeout = "500ms"
	        }  
          ingress {
            listener {
              port     = 5000
              protocol = "http"
              service {
                name = "web-svc"
                hosts = ["*.web-svc.com"]
              }
            }
            listener {
              port     = 9090
              protocol = "http"
              service {
                name = "java-web-svc"
                hosts = ["*.java-web-svc.com"]
              }
            }
          }
        }
      }
    }
  }
}  