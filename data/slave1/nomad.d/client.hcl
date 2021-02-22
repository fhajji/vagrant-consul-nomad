# Config file for a Nomad client.
# 
# Usage:
#    $ sudo nomad agent -config=/etc/hashicorp.d/nomad.d
# 
# Requirement:
#    Consul agent must be running locally.
# 
# This will
#   - start a Nomad client (worker) on this node,
#   - bind to the first (internal) IP address,
#   - register this service with Consul, which
#   - get from Consul the Nomad servers
#   - register this node with those Nomad servers.
#
# Note that we will get the first IP address from the
# list of available network interfaces. This will e.g.
# be something like, say, 10.0.2.15. If we also have
# "external" (bridged) IP addresses like, say 192.168.76.161,
# then we need to advertise them explicitely. If you want
# to do that, uncomment the advertise {} block.

data_dir             = "/var/lib/nomad"
disable_update_check = true
enable_syslog        = true

bind_addr = "0.0.0.0"

advertise {
  # defaults to the first private IP address
  http = "192.168.76.161"
  rpc = "192.168.76.161"
  serf = "192.168.76.161"
}

client {
  enabled = true
  # Uncomment next line if not using Consul
  # servers = ["192.168.76.150", "192.168.76.151", "192.168.76.152"]
}

# Comment this block out, if not using Consul
consul {
  address = "127.0.0.1:8500"
}
