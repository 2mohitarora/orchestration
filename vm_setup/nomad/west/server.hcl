data_dir  = "/opt/nomad/data"
bind_addr = "0.0.0.0"
datacenter = "west-1"
region = "west"

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