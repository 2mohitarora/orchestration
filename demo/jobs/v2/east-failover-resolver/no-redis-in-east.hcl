kind = “service-resolver”
name = “redis-svc”
redirect {
    service = “web”
    datacenters = ["west"]
}
