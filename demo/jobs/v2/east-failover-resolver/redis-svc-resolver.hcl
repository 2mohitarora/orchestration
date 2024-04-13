Kind = "service-resolver"
Name = "redis-svc"
failover = {
 "*" = {
        datacenters = ["west"]
    }
}