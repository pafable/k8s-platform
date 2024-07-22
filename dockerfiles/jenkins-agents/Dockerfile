ARG VERSION=3256.v88a_f6e922152-1
FROM jenkins/inbound-agent:$VERSION

ARG USER=jenkins

RUN ["/bin/sh", "-c", "$(curl --location https://taskfile.dev/install.sh) -- -d"]