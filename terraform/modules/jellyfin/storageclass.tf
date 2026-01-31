resource "kubernetes_storage_class_v1" "jellyfin_nfs_sc" {
  metadata {
    name = "kraken-movies-shows"
  }

  reclaim_policy      = "Retain"
  storage_provisioner = "nfs.csi.k8s.io"

  parameters = {
    server = "kraken.fleet.pafable.com"
    share  = "/volume1/movies-shows"
  }
}