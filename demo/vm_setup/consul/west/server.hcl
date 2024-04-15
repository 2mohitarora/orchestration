server = true
bootstrap_expect = 3
ui_config {
  enabled = true
}
client_addr = "0.0.0.0"
primary_gateways = [ "198.19.249.171:8081", "198.19.249.10:8081", "198.19.249.203:8081" ]
connect {
  enable_mesh_gateway_wan_federation = true
}