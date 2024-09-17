module "k3s_master" {
  source  = "../../modules/proxmox_vm"
  clone   = "orc-template"
  iso     = "OracleLinux-R9-U4-x86_64-boot.iso"
  memory  = 4096
  name    = "uruk-hai-01"
  os_type = "cloud-init"
  tags    = "phil,test"
}