variable "vault_node_fqdn" {
  type = string
}

variable "vault_api_fqdn" {
  type = string
}

variable "raft_data_dir" {
  type    = string
  default = "/vault"
}

variable "initialize_vault" {
  type    = bool
  default = false
}
