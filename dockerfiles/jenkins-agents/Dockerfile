ARG VERSION=3261.v9c670a_4748a_9-1
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

# Installs kubectl
RUN    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
       && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Installs awscli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && sh ./aws/install

RUN usermod -aG docker jenkins

USER root