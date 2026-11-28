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

## Control Plane Node Installation
1. Open ports
```
firewall-cmd --permanent \
    --add-port=6443/tcp \
    --add-port=9345/tcp \
    --add-port=10250/tcp \
    --add-port=2379-2381/tcp \
    --add-port=30000-32767/tcp
```

```
firewall-cmd --reload && firewall-cmd --list-all
```

2. Install RKE2
```
curl -sfL https://get.rke2.io | sh - \
    && systemctl enable --now rke2-server.service \
    && systemctl status rke2-server.service
```

3. Save the token for joining nodes and IP address of the control plane node
```
cat /var/lib/rancher/rke2/server/token
```

## Worker Node Installation
1. Open ports
```
firewall-cmd --permanent \
    --add-port=10250/tcp \
    --add-port=30000-32767/tcp
```

```
firewall-cmd --reload && firewall-cmd --list-all
```

2. Added control plane token
```
vim /etc/rancher/rke2/config.yaml
```
config.yaml should look like this:
```
server: https://<control-plane-ip>:9345
token: <control-plane-token>
```

3. Install RKE2
```
curl -sfL https://get.rke2.io \
    | INSTALL_RKE2_TYPE="agent" sh - \
    && systemctl enable --now rke2-agent.service \
    && systemctl status rke2-agent.service
```