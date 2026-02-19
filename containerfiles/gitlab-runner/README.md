# Deployer Image

```commandline
docker login <REGISTRY_URL>
docker build -f Containerfile -t <REGISTRY_URL>/deployer:<TAG> .
docker push <REGISTRY_URL>/deployer:<TAG>

```