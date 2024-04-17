datacenter = "east"
primary_datacenter = "east"
data_dir = "/opt/consul"
encrypt = "4Ox5PVb2MKOGsYSC3WKH6mFHH22g6nR12NRoWJ5zJps="
ports {
  grpc = 8502
}
bind_addr = "{{ GetInterfaceIP `eth0` }}"
client_addr = "0.0.0.0"