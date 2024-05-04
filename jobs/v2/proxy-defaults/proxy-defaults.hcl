Kind = "proxy-defaults"
Name = "global"
Config = {
    Protocol = "http"
    envoy_prometheus_bind_addr = "0.0.0.0:9102"
}
MeshGateway = {
    mode = "local"
}
