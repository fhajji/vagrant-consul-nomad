# Consul agent for master0
# 
# Start with:
#   $ consul agent -config-dir=/etc/hashicorp.d/consul.d/
# 
# The "encrypt" key for the Gossip protocol was
# generated (only) by master0 with the command:
#   $ consul keygen > /vagrant_data/consul.keygen
# and is reused by all other Consul agents (configs).

data_dir = "/var/consul"
log_level = "INFO"
node_name = "master0"
server = true
encrypt = "atPcSPKra7MO4J5yfQmoFsojIsnzg9gfPlWe4OrLtLw="
bind_addr = "192.168.76.150"
retry_join = ["192.168.76.151", "192.168.76.152"]
bootstrap = true

# Enable Consul Connect
# https://www.nomadproject.io/docs/integrations/consul-connect
ports {
    grpc = 8502
}

connect {
    enabled = true
}

# enable UI only on master0
# accessible as http://127.0.0.1:8500/ui/
# use nginx in reverse proxy mode to make it visible outside
# of localhost.
# See also /etc/hashicorp.d/nginx.d/reverse-proxy
ui_config {
    enabled = true
}
