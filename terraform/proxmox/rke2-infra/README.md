# RKE2 Infrastructure

[RKE2](https://docs.rke2.io/)

## Procedures
1. Open ports:
    
    | Port        | Protocol | Node          | Description            | 
    | ----------- | -------- | ------------- | ---------------------- |
    | 6443        | TCP      | All Nodes     | Kubernetes API server  |
    | 9345        | TCP      | All Nodes     | RKE2 supervisor API    |
    | 10250       | TCP      | All Nodes     | Kubelet metrics        |
    | 2379        | TCP      | Control Plane | etcd client port       |
    | 2380        | TCP      | Control Plane | etcd peer port         |
    | 2381        | TCP      | Control Plane | etcd metrics port      |
    | 30000-32767 | TCP      | All Nodes     | NodePort port range    |
