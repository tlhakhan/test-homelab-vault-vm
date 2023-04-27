terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

resource "docker_network" "vault" {
  name = "vault_network"
}

resource "docker_volume" "vault" {
  name = "vault_keys"
}

resource "docker_image" "vault_init" {
  count = var.initialize_vault ? 1 : 0
  name  = "vault_init"
  build {
    context = "${path.module}/files/vault-init-container"
    tag     = ["vault_init:latest"]
  }
  triggers = {
    dir_sha1 = sha1(join("", [for f in fileset(path.module, "${path.module}/files/vault-init-container/*") : filesha1(f)]))
  }
}

resource "docker_container" "vault_init" {
  count = var.initialize_vault ? 1 : 0
  image = docker_image.vault_init.0.image_id
  name  = "vault_init"

  networks_advanced {
    name = docker_network.vault.name
  }

  volumes {
    volume_name    = docker_volume.vault.name
    container_path = "/vault/keys"
  }
  depends_on = [docker_container.vault]
}

resource "docker_image" "vault" {
  name = "hashicorp/vault:1.13"
}

resource "docker_container" "vault" {
  image = docker_image.vault.image_id
  name  = "vault"
  upload {
    file = "/vault/config/vault.hcl"
    content = templatefile("${path.module}/templates/vault.hcl", {
      raft_data_dir   = var.raft_data_dir
      vault_node_fqdn = var.vault_node_fqdn
      vault_api_fqdn  = var.vault_api_fqdn
    })
  }

  networks_advanced {
    name = docker_network.vault.name
  }

  capabilities {
    add = ["IPC_LOCK"]
  }

  volumes {
    volume_name    = docker_volume.vault.name
    container_path = "/vault/keys"
  }

  ports {
    internal = "8200"
    external = "8200"
  }

  ports {
    internal = "8201"
    external = "8201"
  }

  command = ["vault", "server", "-config", "/vault/config/vault.hcl"]
}

output "vault_keys_mountpoint" {
  value = docker_volume.vault.mountpoint
}
