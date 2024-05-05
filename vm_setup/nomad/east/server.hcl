data_dir  = "/opt/nomad/data"
bind_addr = "0.0.0.0"
datacenter = "east-1"
region = "east"

# Enable the server
server {
  enabled = true
  bootstrap_expect = 3
}
consul {
  address = "127.0.0.1:8500"
}
ui {
  enabled =  false
}