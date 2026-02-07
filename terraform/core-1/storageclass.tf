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

  mount_options = [
    "hard",
    "nfsvers=4.1"
  ]
}

resource "kubernetes_storage_class_v1" "kraken_nfs_media_sc" {
  metadata {
    name = "kraken-media"
  }

  reclaim_policy      = "Retain"
  storage_provisioner = "nfs.csi.k8s.io"

  parameters = {
    server = "kraken.fleet.pafable.com"
    share  = "/volume1/movies-shows"
  }

  mount_options = [
    "hard",
    "nfsvers=4.1"
  ]
}