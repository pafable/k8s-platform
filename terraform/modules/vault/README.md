# VAULT

Once deployed to a kubernetes cluster you will need to initialize the leader node only and unseal all of the nodes.

### Leader Node Commands
```shell
vault operator init
```

Save unseal keys and root token.


### Follower Node Commands
Run these commands on all follower nodes.
```shell
export VAULT_ADDR="http://FOLLOWER_NODE_IP:8200"
export VAULT_TOKEN=<ROOT_TOKEN>
vault operator raft join http://<LEADER_NODE_IP>:8200

# run unseal command 3 times use a different key each time
vault operator unseal <UNSEAL_KEY>
```