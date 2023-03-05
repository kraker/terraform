terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "2.9.13"
    }
  }
}

provider "proxmox" {
  pm_user = "terraform-prov@pve"
  pm_tls_insecure = true
  pm_api_url = "https://192.168.0.176:8006/api2/json"
}

variable "ssh_key" {
  type = string
  default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBLiiz/AhH/lc08OzoY0/gD3ouVUxeEAivbAyXONqJLi akraker@Ubuntu-PF3TFBEH-1255"
}

output "vm_ip" { value = proxmox_vm_qemu.tf_tests.*.default_ipv4_address }

resource "proxmox_vm_qemu" "tf_tests" {
    count = 1
    name = "tf-${count.index + 1}"
    target_node = "mars"
    clone = "ubuntu1804-template"
    agent = 1
    os_type = "cloud-init"
    cores = 1
    sockets = 1
    cpu = "host"
    memory = 2048
    scsihw = "virtio-scsi-pci"
    bootdisk = "scsi0"

    disk {
        slot = 0
        size = "16G"
        type = "scsi"
        storage = "store01"
        iothread = 1
    }

    network {
        model = "virtio"
        bridge = "vmbr0"
    }

    lifecycle {
        ignore_changes = [
            network,
        ]
    }

    ipconfig0 = "ip=192.168.0.21${count.index + 1}/24,gw=192.168.0.1"

    sshkeys = <<EOF
    ${var.ssh_key}
    EOF
}