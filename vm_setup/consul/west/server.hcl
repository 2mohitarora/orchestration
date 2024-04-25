server = true
bootstrap_expect = 3
ui_config {
  enabled = true
}
primary_gateways = [ "198.19.249.240:8081", "198.19.249.19:8081", "198.19.249.177:8081" ]
connect {
  #enable_mesh_gateway_wan_federation = true
}