output "vm_ip" {
  value = proxmox_vm_qemu.autobots.*.default_ipv4_address
}
