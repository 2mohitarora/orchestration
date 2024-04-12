Kind = "api-gateway"
Name = "east-gateway"

// Each listener configures a port which can be used to access the Consul cluster
Listeners = [
    {
        Port = 8443
        Name = "east-http-listener"
        Protocol = "http"
    }
]
