module "k3s_master" {
  source = "../../modules/proxmox_vm"
  iso    = "OracleLinux-R9-U4-x86_64-boot.iso"
  name   = "orc"
  tags   = "phil,test"
}