datacenter = "west"
primary_datacenter = "east"
data_dir = "/opt/consul"
encrypt = "4Ox5PVb2MKOGsYSC3WKH6mFHH22g6nR12NRoWJ5zJps="
ports {
  grpc = 8502
  grpc_tls = 8503
}
bind_addr = "{{ GetInterfaceIP `eth0` }}"
client_addr = "0.0.0.0"
tls {
  defaults {
    verify_outgoing = true
    verify_server_hostname = true
    ca_file = "/etc/consul.d/ssl/consul-agent-ca.pem"
    verify_incoming = true
    cert_file = "/etc/consul.d/ssl/server-consul-0.pem"
    key_file = "/etc/consul.d/ssl/server-consul-0-key.pem"
  }
}
auto_encrypt {
  allow_tls = true
}
server = true
bootstrap_expect = 3
connect {
  #enable_mesh_gateway_wan_federation = true
}
primary_gateways = [ "east-gateways-node1.orb.local:8081", "east-gateways-node2.orb.local:8081", "east-gateways-node3.orb.local:8081" ]