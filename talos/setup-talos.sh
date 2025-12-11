#!/usr/bin/env bash

set -euxo pipefail


SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
CONFIG_DIR="${SCRIPT_DIR}/config"
PATCH_DIR="${SCRIPT_DIR}/patches"
CLUSTER_NAME="talos-cluster"
IMAGE="factory.talos.dev/installer/ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515:v1.11.5"

# Node IPs
CONTROL_PLANE1=$1
CONTROL_PLANE2=$2
WORKER_NODE1=$3
WORKER_NODE2=$4
WORKER_NODE3=$5


## create talos secrets
talosctl gen secrets -o "${CONFIG_DIR}/secrets.yaml" --force


# create talos machine configs
talosctl gen config "${CLUSTER_NAME}" \
    https://"${CONTROL_PLANE1}":6443 \
    --output-dir "${CONFIG_DIR}" \
    --config-patch @"${PATCH_DIR}"/cni.yaml \
    --install-image "${IMAGE}" \
    --with-secrets "${CONFIG_DIR}/secrets.yaml" \
    --force


# apply control plane config
controlplane_ips=("${CONTROL_PLANE1}" "${CONTROL_PLANE2}")
for contolplane in "${controlplane_ips[@]}"; do
  talosctl apply-config \
    --insecure \
    --nodes "${contolplane}" \
    --file "${CONFIG_DIR}/controlplane.yaml"
done


# apply worker config
worker_ips=("${WORKER_NODE1}" "${WORKER_NODE2}" "${WORKER_NODE3}")
for worker in "${worker_ips[@]}"; do
  talosctl apply-config \
    --insecure \
    --nodes "${worker}" \
    --file "${CONFIG_DIR}/worker.yaml"
done


# configure talos endpoint
talosctl config endpoint "${CONTROL_PLANE1}"


## apply patches on controlpane nodes
#for contolplane in "${controlplane_ips[@]}"; do
#  for ((i=1; i<3; i++)); do
#    talosctl patch mc \
#      --talosconfig "${CONFIG_DIR}"/talosconfig \
#      --nodes "${contolplane}" \
#      --patch @"${PATCH_DIR}"/controller-"${i}"-hostname.yaml
#
#    talosctl reboot \
#      --talosconfig "${CONFIG_DIR}"/talosconfig \
#      --nodes "${contolplane}"
#  done
#done
#
#
## apply patches on worker nodes
#for worker in "${worker_ips[@]}"; do
#  for ((i=1; i<4; i++)); do
#    talosctl patch mc \
#      --talosconfig "${CONFIG_DIR}"/talosconfig \
#      --nodes "${worker}" \
#      --patch @"${PATCH_DIR}"/worker-"${i}"-hostname.yaml
#
#    talosctl reboot \
#      --talosconfig "${CONFIG_DIR}"/talosconfig \
#      --nodes "${worker}"
#  done
#done


# get talos members
sleep 30 # need to wait for controlplane to be ready
talosctl get members --nodes "${CONTROL_PLANE1}"


# bootstrap cluster
talosctl bootstrap --nodes "${CONTROL_PLANE1}"


# get kubeconfig
talosctl kubeconfig \
  --nodes "${CONTROL_PLANE1}" \
  "${CONFIG_DIR}"


echo -e "\nKubernetes cluster is up and running!"