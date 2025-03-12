#!/usr/bin/env bash

set -euxo pipefail

# put this script on your local dnf/yum repo server to retrieve baseos, appstream, etc packages
# run this script before executing task to build images!

repo_dir="/srv/repos/almalinux9"
repo_ids=("appstream" "baseos" "crb" "epel" "epel-cisco-openh264" "extras" "hashicorp")

if [ -d "${repo_dir}" ]; then
  mkdir -p "${repo_dir}"
fi

for repo_id in "${repo_ids[@]}"
do
  reposync -n --download-metadata --repoid="${repo_id}" -p "${repo_dir}"
done
