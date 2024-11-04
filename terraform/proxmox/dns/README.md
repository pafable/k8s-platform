# DNS

This will connect to the DNS server and update records.

## Preqrequistes
Create a tsig key and put it in your DNS server before running this command. NOTE use `hmac-sha256` when generating key.
Upload the key to AWS SSM Parameter Store with the name `/proxmox/dns/server/tsig/key`. Terraform will retrieve this key to authenticate with the DNS server.


See [docs](https://bind9.readthedocs.io/en/v9.18.2/advanced.html#tsig) for more info.

## Create records
```shell
task dns-entries-create
```

## Destroy records
```shell
task dns-entries-destroy
```