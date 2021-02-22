data_dir             = "/var/lib/nomad"
disable_update_check = true
enable_syslog        = true

bind_addr = "0.0.0.0"

advertise {
  # defaults to the first private IP address
  http = "192.168.76.152"
  rpc = "192.168.76.152"
  serf = "192.168.76.152"
}

server {
  enabled          = true
  bootstrap_expect = 3

  server_join {
    retry_join = ["192.168.76.150", "192.168.76.151"]
  }
}

# client {
#   enabled = true
# }

# consul {
#   address = "192.168.76.150:8500"
# }
