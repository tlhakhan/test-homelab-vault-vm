terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

terraform {
  backend "local" {
    path = ".tfstate"
  }
}

provider "docker" {
  host     = "ssh://root@vault-1:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
  alias    = "vault_1"
}

module "vault_1" {
  source           = "./modules/vault-install"
  vault_node_fqdn  = "vault-1.tenzin.io"
  vault_api_fqdn   = "vault-ha.tenzin.io"
  initialize_vault = true
  providers = {
    docker = docker.vault_1
  }
}
