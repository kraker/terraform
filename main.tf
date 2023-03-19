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

resource "proxmox_vm_qemu" "Win10" {
  agent                  = 1
  balloon                = 4096
  bios                   = "seabios"
  boot                   = "order=scsi0;ide2;net0;ide0"
  cores                  = 2
  cpu                    = "host"
  define_connection_info = false
  force_create           = false
  full_clone             = false
  hotplug                = "network,disk,usb"
  kvm                    = true
  memory                 = 8192
  name                   = "Win10"
  numa                   = false
  onboot                 = false
  oncreate               = false
  qemu_os                = "win10"
  scsihw                 = "virtio-scsi-pci"
  sockets                = 1
  tablet                 = true
  target_node            = "mars"
  vcpus                  = 0

  disk {
    backup             = true
    cache              = "writeback"
    discard            = "on"
    file               = "vm-102-disk-0"
    format             = "raw"
    iops               = 0
    iops_max           = 0
    iops_max_length    = 0
    iops_rd            = 0
    iops_rd_max        = 0
    iops_rd_max_length = 0
    iops_wr            = 0
    iops_wr_max        = 0
    iops_wr_max_length = 0
    iothread           = 0
    mbps               = 0
    mbps_rd            = 0
    mbps_rd_max        = 0
    mbps_wr            = 0
    mbps_wr_max        = 0
    replicate          = 0
    size               = "50G"
    slot               = 0
    ssd                = 0
    storage            = "local-zfs"
    type               = "scsi"
    volume             = "local-zfs:vm-102-disk-0"
  }

  network {
    bridge    = "vmbr0"
    firewall  = false
    link_down = false
    macaddr   = "8E:1B:4B:65:3B:CD"
    model     = "virtio"
    mtu       = 0
    queues    = 0
    rate      = 0
    tag       = -1
  }

  timeouts {}
}
