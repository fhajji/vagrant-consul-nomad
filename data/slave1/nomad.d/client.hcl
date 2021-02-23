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
# Note that we MUST advertise an external / bridged IP address
# or an internal IP address using an advertise {} block.
# Because if we don't, this will get the first IP address from
# the list of available network interfaces. This will e.g. be
# something like, say, 10.0.2.15 (the NAT interface created
# by Vagrant).
# Alternatively, bind_addr to the address you want; it will
# be advertised if no advertise{} block is available.

data_dir             = "/var/lib/nomad"
disable_update_check = true
enable_syslog        = true

# bind_addr = "192.168.76.161"
# bind_addr = "10.0.0.161"
bind_addr = "0.0.0.0"

advertise {
  http = "10.0.0.161"
  rpc = "10.0.0.161"
  serf = "10.0.0.161"
}

client {
  enabled = true

  # Uncomment next line if not using Consul
  # servers = ["192.168.76.150", "192.168.76.151", "192.168.76.152"]

  # Uncomment next line if not using Consul
  # servers = ["10.0.0.150", "10.0.0.151", "10.0.0.152"]
}

# Comment this block out, if not using Consul
consul {
  address = "127.0.0.1:8500"
}
