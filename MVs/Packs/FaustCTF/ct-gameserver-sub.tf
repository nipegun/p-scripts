resource "proxmox_virtual_environment_container" "gameserver-sub" {
  description = "Managed by Terraform"

  node_name = var.pve-node

  vm_id     = 1990

  initialization {
    hostname = "gameserver-sub"

    ip_config {
      ipv4 {
        address = var.gameserver-sub-priv-ip-CIDR
        gateway = var.gameserver-sub-priv-gw
      }
    }

    user_account {
      keys = [
        trimspace(tls_private_key.gameserver-tls-key.public_key_openssh)
      ]
      password = random_password.gameserver_password.result
    }
  }

  cpu {
    cores = 2
  }

  memory {
    dedicated = 2048
  }

  disk {
      datastore_id = var.pve-vm-ds
  }

  network_interface {
    name    = "eth0"
    bridge  = "vmbr999"
    vlan_id = "254"
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
