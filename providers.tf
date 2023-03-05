provider "proxmox" {
  pm_user         = "terraform-prov@pve"
  pm_tls_insecure = true
  pm_api_url      = "https://192.168.0.176:8006/api2/json"
}
