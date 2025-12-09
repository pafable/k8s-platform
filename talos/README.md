# Talos Linux

This will deploy a kubernetes cluster using Talos Linux.

Deploys a 5 node cluster with 2 master and 3 worker nodes. You will need to have `talosctl` and `kubectl` installed on your workstation.
You will also need `sops` and `age` to encrypt talos configuration files.b

## Manual Process
### Create environment variables
```commandline
export CONTROL_PLANE1=<IP_ADDRESS>
export CONTROL_PLANE2=<IP_ADDRESS>
export WORKER_NODE1=<IP_ADDRESS>
export WORKER_NODE2=<IP_ADDRESS>
export WORKER_NODE3=<IP_ADDRESS>
```

### Generate Secrets
Store secrets.yaml in your secure credential store. Make sure this is encrypted before committing it into your git repository. 
```commandline
talosctl gen secrets -o config/secrets.yaml 
```

### Generate cluster configs
Use `@` to ensure yaml files are rendered as yaml instead of json
```commandline
talosctl gen config <YOUR_CLUSTER_NAME> https://$CONTROL_PLANE1:6443 \
    --output-dir config \
    --with-secrets config/secrets.yaml \
    --config-patch @patches/allow-controlplane-workloads.yaml \
    --config-patch @patches/cni.yaml \
    --config-patch @patches/dhcp.yaml \
    --config-patch @patches/install-disk.yaml \
    --config-patch @patches/interface-names.yaml \
    --config-patch @patches/kubelet-certificate.yaml \
    --config-patch-control-plane @patches/vip.yaml \
    --output config/
```

If you do not want to use patches run the following. NOTE by default networking is handled by flannel in Talos.
```commandline
talosctl gen config <YOUR_CLUSTER_NAME> https://$CONTROL_PLANE1:6443 \
    --output-dir config \
    --with-secrets config/secrets.yaml
```

If using qemu-guest-agent use this command. This uses url for v1.11.5 as an example.
```commandline
talosctl gen config <YOUR_CLUSTER_NAME> \
    https://$CONTROL_PLANE1:6443 \
    --output-dir config \
    --install-image factory.talos.dev/installer/ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515:v1.11.5 \
    --with-secrets config/secrets.yaml
```

### Apply Configs
Use the `--insecure` because the pki has not been deployed on the cluster. 

Control plane nodes:
```commandline
talosctl apply-config \
    --insecure \
    --nodes $CONTROL_PLANE1 \
    --file config/controlplane.yaml
```

```commandline
talosctl apply-config \
    --insecure \
    --nodes $CONTROL_PLANE2 \
    --file config/controlplane.yaml
```

Worker nodes:
```commandline
talosctl apply-config \
    --insecure \
    --nodes $WORKER_NODE1 \
    --file config/worker.yaml
```

```commandline
talosctl apply-config \
    --insecure \
    --nodes $WORKER_NODE2 \
    --file config/worker.yaml
```

```commandline
talosctl apply-config \
    --insecure \
    --nodes $WORKER_NODE3 \
    --file config/worker.yaml
```

```commandline
export TALOSCONFIG=/somepath/config/talosconfig
```

### Configure Cluster Endpoints
```commandline
talosctl config endpoint $CONTROL_PLANE1
```
If you have multiple control nodes append them one right after the other separating them with spaces.

### Check Talos Dashboard 
```commandline
talosctl dashboard --nodes $CONTROL_PLANE1
```

### Check Node Members
This command is similar to `kubectl get nodes`
```commandline
talosctl get members --nodes $CONTROL_PLANE1
```

### Bootstrap Kubernetes Services
This will bootstrap and initialize the kubernetes services on the cluster. Only do this on a single control plane node.
```commandline
talosctl bootstrap --nodes $CONTROL_PLANE1
```

### Retrieve Kubeconfig
```commandline
talosctl kubeconfig --nodes $CONTROL_PLANE1 /somepath/to/config/dir
```

### Verification
```commandline
kubectl get nodes --kubeconfig=kubeconfig
kubectl get all --kubeconfig=kubeconfig -o wide
```

### Encrypting configs
Create key
```commandline
age-keygen -o age-key.txt
```

Copy the age public key from `age-key.txt` and use it in the `sops` command.
```commandline
for file in $(ls config/); \
    do sops --encrypt config/$file > "${file%.yaml}.enc.yaml"; \
    done
```

To decrypt run the following.
```commandline
for file in $(ls config/); \
    do sops --decrypt  config/$file > "${file%.enc.yaml}.yaml"; \
    done
```

## Automated
```commandline
./setup-talos.sh \
    CONTROL_PLANE1_IP \
    CONTROL_PLANE2_IP \
    WORKER_NODE1_IP \
    WORKER_NODE2_IP \
    WORKER_NODE3_IP
```






Notes



Use this if node is already initialized and running
```commandline
 talosctl patch mc --nodes <CONTROL_PLANE1> --patch @worker-1-hostname.yaml 
```