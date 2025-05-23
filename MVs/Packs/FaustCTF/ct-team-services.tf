resource "proxmox_virtual_environment_container" "services" {
  description = "Managed by Terraform"

  node_name = var.pve-node

  count = var.team-count

  vm_id     = 1001 + count.index

  memory {
    dedicated = 1024
  }

  initialization {
    hostname = "team${1 + count.index}-services"

    ip_config {
      ipv4 {
        address = "10.0.${1 + count.index}.101/24"
        gateway = "10.0.${1 + count.index}.254"
      }
    }

    user_account {
      keys = [
        trimspace(tls_private_key.team-tls-key[count.index].public_key_openssh)
      ]
      password = random_password.services_password.result
    }
  }

  disk {
      datastore_id = var.pve-vm-ds
      size         = 40
  }

  network_interface {
    name    = "eth0"
    bridge  = "vmbr999"
    vlan_id = "${101 + count.index}"
  }

  features {
    nesting = true
  }
  
  operating_system {
    template_file_id = "local-lvm:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst"
    type             = "debian"
  }

#  mount_point {
#    volume = "/mnt/bindmounts/shared"
#    path   = "/shared"
#  }

}

resource "random_password" "services_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}

output "services-password" {
  value = random_password.services_password.result
  sensitive = true
}
