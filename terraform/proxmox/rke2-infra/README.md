# RKE2 Infrastructure

[RKE2](https://docs.rke2.io/)

File location:

- kubectl - `/var/lib/rancher/rke2/bin/kubectl`
- rke2-killall.sh & rke2-uninstall.sh - `/usr/bin`
- kubeconfig - `/etc/rancher/rke2/rke2.yaml`
- token - `/var/lib/rancher/rke2/server/node-token`

## Procedures
1. Open ports:
    
    | Port        | Protocol | Node          | Description            | 
    | ----------- | -------- | ------------- | ---------------------- |
    | 6443        | TCP      | Control Plane     | Kubernetes API server  |
    | 9345        | TCP      | Control Plane   | RKE2 supervisor API    |
    | 10250       | TCP      | All Nodes     | Kubelet metrics        |
    | 2379        | TCP      | Control Plane | etcd client port       |
    | 2380        | TCP      | Control Plane | etcd peer port         |
    | 2381        | TCP      | Control Plane | etcd metrics port      |
    | 30000-32767 | TCP      | All Nodes     | NodePort port range    |
