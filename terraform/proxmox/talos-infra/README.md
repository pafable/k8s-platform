# Talos Infrastructure

Creates a Talos infrastructure with 1 controlplane and 2 worker nodes.

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

