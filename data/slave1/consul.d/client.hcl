# Consul agent for slave1
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
node_name = "slave1"
server = false
encrypt = "atPcSPKra7MO4J5yfQmoFsojIsnzg9gfPlWe4OrLtLw="
bind_addr = "192.168.76.161"
retry_join = ["192.168.76.151", "192.168.76.150", "192.168.76.152"]
ui_config {
    enabled = false
}
