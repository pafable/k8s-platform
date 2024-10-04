# Hive Tyrant

Checks to confirm if a Proxmox server has all it's nodes.

1. Create a `config.ini` file in this folder and fill with you Proxmox credentials.
```shell
PM_HOST = <HOST>
PM_USER = <USER>
PM_TOKEN_NAME = <TOKEN_NAME>
PM_TOKEN_VALUE = <TOKEN_VALUE>
```

You can also set environment variables instead of using a `config.ini`, however if a `config.ini` it will take precedence over environment variables.