locals {
  helper_path = "${abspath(path.root)}/../modules/helper-scripts"
}

data "external" "check_crd" {
  program = ["bash", "${local.helper_path}/check-crd.sh"]

  query = {
    crd = "gatewayclasses"
  }
}