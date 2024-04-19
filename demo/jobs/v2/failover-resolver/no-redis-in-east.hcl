kind = "service-resolver"
name = "redis-svc"
redirect {
    service = "redis-svc"
    datacenter = "west"
}
