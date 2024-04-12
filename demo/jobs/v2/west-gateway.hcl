Kind = "api-gateway"
Name = "west-gateway"

// Each listener configures a port which can be used to access the Consul cluster
Listeners = [
    {
        Port = 8443
        Name = "west-http-listener"
        Protocol = "http"
    }
]
