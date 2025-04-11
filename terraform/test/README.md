# S3 State Lock File

This is a test of using S3 lock file instead of DynamoDB

### Init
```shell
terraform init \
  -backend-config="bucket=<BUCKET_NAME>" \
  -backend-config="encrypt=true" \
  -backend-config="key=<TF_STATE_FILE>" \
  -backend-config="region=<AWS_REGION>" \
  -backend-config="use_lockfile=true" \
  -upgrade \
  -reconfigure 
```

### Workspace
```shell
terraform workspace select -or-create <WORKSPACE_NAME>
```

### Plan
```shell
terraform plan -out=<TF_PLAN>
```

### Apply
```shell
terraform apply <TF_PLAN>
```

### Destroy
```shell
terraform apply -destroy -auto-approve
```