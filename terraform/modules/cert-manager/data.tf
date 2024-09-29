locals {
  helper_path   = "${abspath(path.root)}/../modules/helper-scripts"
  install_count = tobool(data.external.check_crd.result["installed"]) ? 1 : 0
}

data "external" "check_crd" {
  program = ["bash", "${local.helper_path}/check-crd.sh"]

  query = {
    crd = "clusterissuers"
  }
}