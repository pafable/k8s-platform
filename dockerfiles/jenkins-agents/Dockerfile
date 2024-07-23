ARG VERSION=3256.v88a_f6e922152-1
FROM jenkins/inbound-agent:$VERSION

USER root

RUN sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin

RUN apt update && curl -fsSL https://get.docker.com | sh

RUN usermod -aG docker jenkins

USER jenkins