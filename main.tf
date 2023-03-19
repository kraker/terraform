terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.13"
    }
  }
}

resource "proxmox_vm_qemu" "autobots" {
  name        = "autobots"
  target_node = var.target_node
  clone       = "opensuse15sp4-template"
  agent       = 1
  os_type     = "cloud-init"
  qemu_os     = "other"
  cores       = 2
  sockets     = 1
  cpu         = "host"
  memory      = 4096
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"
  onboot      = true

  disk {
    slot    = 0
    size    = "50G"
    type    = "scsi"
    storage = "local-zfs"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ipconfig0 = "ip=192.168.0.201/24,gw=192.168.0.1"

  sshkeys = <<EOF
    ${var.ssh_key}
    EOF
}

resource "proxmox_vm_qemu" "teleport" {
  name        = "teleport"
  target_node = var.target_node
  clone       = "opensuse15sp4-template"
  agent       = 1
  os_type     = "cloud-init"
  qemu_os     = "other"
  cores       = 1
  sockets     = 1
  cpu         = "host"
  memory      = 2048
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"

  disk {
    slot    = 0
    size    = "35G"
    type    = "scsi"
    storage = "local-zfs"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ipconfig0 = "ip=192.168.0.202/24,gw=192.168.0.1"

  sshkeys = <<EOF
    ${var.ssh_key}
    EOF
}
