data_dir = "/var/consul"
log_level = "INFO"
node_name = "master2"
server = true
encrypt = "atPcSPKra7MO4J5yfQmoFsojIsnzg9gfPlWe4OrLtLw="
bind_addr = "192.168.76.152"
retry_join = ["192.168.76.150", "192.168.76.151"]
# bootstrap = false
ui_config {
    enabled = false
}
