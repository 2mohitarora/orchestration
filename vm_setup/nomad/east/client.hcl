data_dir  = "/opt/nomad/data"
bind_addr = "0.0.0.0"
datacenter = "east-1"
region = "east"

# Enable the client
client {
  enabled = true
  options {
    "driver.raw_exec.enable"    = "1"
    "docker.privileged.enabled" = "true"
  }
}
consul {
  address = "127.0.0.1:8500"
}