output "autobots_ip" {
  value = proxmox_vm_qemu.autobots.*.default_ipv4_address
}

output "Win10_ip" {
  value = proxmox_vm_qemu.Win10.*.default_ipv4_address
}
