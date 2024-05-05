datacenter = "east"
primary_datacenter = "east"
data_dir = "/opt/consul"
encrypt = "4Ox5PVb2MKOGsYSC3WKH6mFHH22g6nR12NRoWJ5zJps="
ports {
  grpc_tls = 8503
}
bind_addr = "{{ GetInterfaceIP `eth0` }}"
client_addr = "0.0.0.0"
tls {
  defaults {
    verify_outgoing = true
    verify_server_hostname = true
    ca_file = "/etc/consul.d/ssl/consul-agent-ca.pem"
    verify_incoming = false
  }
}
auto_encrypt = {
  tls = true
}