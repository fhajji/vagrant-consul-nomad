data_dir = "/var/consul"
log_level = "INFO"
node_name = "master0"
server = true
encrypt = "atPcSPKra7MO4J5yfQmoFsojIsnzg9gfPlWe4OrLtLw="
bind_addr = "192.168.76.150"
retry_join = ["192.168.76.151", "192.168.76.152"]
# bootstrap = true

# enable UI only on master0
# accessible as http://127.0.0.1:8500/ui/
# use nginx in reverse proxy mode to make it visible outside
ui_config {
    enabled = true
}
