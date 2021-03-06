# Config file for a Nomad server.
# 
# Usage:
#    $ sudo nomad agent -config=/etc/hashicorp.d/nomad.d
# 
# Requirement:
#    Consul agent must be running locally.
# 
# This will
#   - start a Nomad server on this node,
#   - bind to the advertised (external / bridged) IP address,
#   - register this service with Consul, which
#   - get from Consul the _other_ Nomad servers
#   - join this node to those _other_ Nomad servers.
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

# bind_addr = "192.168.76.151"
# bind_addr = "10.0.0.151"
bind_addr = "0.0.0.0"

advertise {
  http = "10.0.0.151"
  rpc = "10.0.0.151"
  serf = "10.0.0.151"
}

server {
  enabled          = true
  bootstrap_expect = 3

  # Uncomment this block if not using Consul
  # server_join {
  #   retry_join = ["192.168.76.150", "192.168.76.152"]
  # }

  # Uncomment this block if not using Consul
  # server_join {
  #   retry_join = ["10.0.0.150", "10.0.0.152"]
  # }
}

# Comment this block out, if not using Consul
consul {
  address = "127.0.0.1:8500"
}
