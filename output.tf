output "autobot_ip" {
  value = proxmox_vm_qemu.autobots.*.default_ipv4_address
}

output "teleport_ip" {
  value = proxmox_vm_qemu.teleport.*.default_ipv4_address
}
