data_dir  = "/opt/nomad/data"
bind_addr = "0.0.0.0"
datacenter = "west-1"
region = "west"

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