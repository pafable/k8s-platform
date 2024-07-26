ARG VERSION=3256.v88a_f6e922152-1
FROM jenkins/inbound-agent:$VERSION

USER root

# Installs taskfile
RUN sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin

# Installs packages
RUN apt update \
    && apt upgrade -y \
    && apt install -y curl \
      golang \
      groff \
      jq \
      less \
      python3 \
      unzip \
      wget

# Installs docker
RUN curl -fsSL https://get.docker.com | sh

# Installs awscli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && sh ./aws/install

RUN usermod -aG docker jenkins

USER root