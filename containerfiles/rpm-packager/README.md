# RPM Packager

```commandline
docker login <REGISTRY_URL>

docker build \
    --no-cache \
    --platform linux/amd64 \
    --file <CONTAINER_FILE> \
    --tag <REGISTRY_URL>/<NAME>:<TAG>

docker push <REGISTRY_URL>/<NAME>:<TAG>
```