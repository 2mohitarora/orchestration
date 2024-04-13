Kind = "service-resolver"
Name = "java-web-svc"
failover = {
 "*" = {
        datacenters = ["east"]
    }
}