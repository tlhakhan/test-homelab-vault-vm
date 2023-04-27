storage "raft" {
  path = "${raft_data_dir}"
  node_id = "${vault_node_fqdn}"
}

listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = "true"
}

api_addr = "https://${vault_api_fqdn}:8200"
cluster_addr = "https://${vault_node_fqdn}:8201"

ui = true
disable_mlock = true
disable_cache = true
log_level = "info"
