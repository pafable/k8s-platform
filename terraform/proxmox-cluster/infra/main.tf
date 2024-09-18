module "k3s_master" {
  source  = "../../modules/proxmox_vm"
  clone   = "orc-template"
  memory  = 4096
  name    = "uruk-hai-01"
  os_type = "cloud-init"
  tags    = "phil,test"
}