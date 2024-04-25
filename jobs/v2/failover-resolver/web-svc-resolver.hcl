Kind = "service-resolver"
Name = "web-svc"
failover = {
 "*" = {
        datacenters = ["west", "east"]
    }
}