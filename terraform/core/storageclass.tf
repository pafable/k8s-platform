resource "kubernetes_storage_class_v1" "kraken_nfs_sc" {
  metadata {
    name = "kraken"
  }

  reclaim_policy      = "Retain"
  storage_provisioner = "nfs.csi.k8s.io"

  parameters = {
    server = "kraken.fleet.pafable.com"
    share  = "/volume2/fs"
  }
}