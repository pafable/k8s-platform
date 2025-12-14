# Talos Infrastructure

Creates a Talos infrastructure with 2 controlplane and 3 worker nodes.

Uses `time.nist.gov` and `us.pool.ntp.org` as ntp servers. Disables default cni (flannel) and uses none. 

Configures the following hostnames on one of the nodes in the cluster:
- controller-01
- controller-02
- worker-01
- worker-02
- worker-03

### Intialize terraform
```commandline
terraform init \
    -backend-config="<S3_BUCKET>" \
    -backend-config="encrypt=true" \
    -backend-config="key=<PATH_IN_S3_BUCKET>" \
    -backend-config="region=<AWS_REGION>" \
    -upgrade \
    -reconfigure
```

### Create Talos nodes
```commandline
terraform apply
```

### Destroy Talos noodes
```commandline
terraform destroy
```

