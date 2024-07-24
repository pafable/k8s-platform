ARG VERSION=3256.v88a_f6e922152-1
FROM jenkins/inbound-agent:$VERSION

USER root

RUN sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin

RUN apt update \
    && apt upgrade -y \
    && apt install -y curl \
      golang \
      jq \
      python3 \
    && curl -fsSL https://get.docker.com | sh

RUN usermod -aG docker jenkins

USER root