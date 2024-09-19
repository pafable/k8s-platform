module "k3s_master" {
  source   = "../../modules/proxmox_vm"
  clone    = "orc-template"
  memory   = 8192
  name     = "uruk-hai-01"
  os_type  = "cloud-init"
  pve_node = "horde"
  tags     = "phil,test"
}

module "k3s_worker1" {
  source    = "../../modules/proxmox_vm"
  clone     = "shinobi-template"
  host_node = "ninja"
  memory    = 8192
  name      = "uruk-hai-02"
  os_type   = "cloud-init"
  pve_node  = "ninja"
  tags      = "phil,test"
}

module "k3s_worker2" {
  source    = "../../modules/proxmox_vm"
  clone     = "shinobi-template"
  host_node = "ninja"
  memory    = 8192
  name      = "uruk-hai-03"
  os_type   = "cloud-init"
  pve_node  = "ninja"
  tags      = "phil,test"
}