ARG VERSION=3256.v88a_f6e922152-1
FROM jenkins/inbound-agent:$VERSION

USER root

RUN sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin

RUN apt update \
    && apt upgrade -y \
    && apt install -y curl \
      glibc \
      golang \
      groff \
      jq \
      less \
      python3 \
      wget \
    && curl -fsSL https://get.docker.com | sh \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && sudo ./aws/install

RUN usermod -aG docker jenkins

USER root