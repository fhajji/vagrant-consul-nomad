data_dir             = "/var/lib/nomad"
disable_update_check = true
enable_syslog        = true

bind_addr = "0.0.0.0"

advertise {
  # defaults to the first private IP address
  http = "192.168.76.162"
  rpc = "192.168.76.162"
  serf = "192.168.76.162"
}

client {
  enabled = true
  servers = ["192.168.76.150", "192.168.76.151", "192.168.76.152"]
}

# consul {
#   address = "192.168.76.150:8500"
# }
