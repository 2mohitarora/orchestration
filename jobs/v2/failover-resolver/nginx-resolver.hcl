Kind = "service-resolver"
Name = "nginx"
failover = {
 "*" = {
        datacenters = ["west", "east"]
    }
}