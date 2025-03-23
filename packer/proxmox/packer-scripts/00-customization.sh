#!/usr/bin/env bash

# this script will customize things like vim, output color when using ls, and will set dnf to use local dnf/yum repository.

set -euo pipefail

MY_USER="deployer"

echo "I AM $(whoami)"
ls -ahl /home

# wipe out machine-id entry
truncate -s 0 /etc/machine-id

cloud-init clean

# move repo and customization files to correct dirs
find /tmp -name '*.repo' -exec mv -fv '{}' /etc/yum.repos.d/ \;
find /tmp -name 'colorls.sh' -exec mv -fv '{}' /etc/profile.d/ \;
find /tmp -name 'jail.local' -exec cp -f '{}' /etc/fail2ban/jail.local \;
find /tmp -name 'vimrc' -exec cp -f '{}' /root/.vimrc \;
find /tmp -name 'vimrc' -exec mv -fv '{}' /home/${MY_USER}/.vimrc \;

# rebuild dnf cache and update and upgrade packages
dnf clean all
dnf makecache
dnf update -y

# stamp image creation date
date > /home/${MY_USER}/image_creation_date

# apply ownership of dirs and files contained in the them
chown -R root: /etc/yum.repos.d
chown -R root: /etc/profile.d
chown -R root: /root
chown -R ${MY_USER}: /home/${MY_USER}

systemctl start fail2ban
systemctl enable fail2ban