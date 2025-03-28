ARG VERSION=3283.v92c105e0f819-5
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
      iputils-ping \
      jq \
      less \
      make \
      python3 \
      unzip \
      wget

# Installs awscli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && sh ./aws/install

# Installs kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Installs packer
RUN curl -o /tmp/packer_1.11.2_linux_amd64.zip "https://releases.hashicorp.com/packer/1.11.2/packer_1.11.2_linux_amd64.zip" \
    && unzip /tmp/packer_1.11.2_linux_amd64.zip -d /tmp \
    && mv /tmp/packer /usr/local/bin \
    && rm -fv /tmp/packer* /tmp/LICENSE.txt

USER jenkins