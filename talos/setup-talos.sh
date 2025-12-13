#!/usr/bin/env bash

set -euo pipefail


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


# create talos secrets
talosctl gen secrets -o "${CONFIG_DIR}/secrets.yaml" --force


# create talos machine configs
talosctl gen config "${CLUSTER_NAME}" \
    https://"${CONTROL_PLANE1}":6443 \
    --output-dir "${CONFIG_DIR}" \
    --config-patch @"${PATCH_DIR}"/cni.yaml \
    --config-patch @"${PATCH_DIR}"/ntp.yaml \
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
talosctl config endpoint "${CONTROL_PLANE1}" \
  --talosconfig "${CONFIG_DIR}"/talosconfig


# apply patches on controlpane nodes
echo "Waiting 30 sec for nodes to be ready..."
sleep 30 # need to wait for controlplane to be ready

talosctl patch mc \
  --talosconfig "${CONFIG_DIR}"/talosconfig \
  --nodes "${CONTROL_PLANE1}" \
  --mode reboot \
  --patch @"${PATCH_DIR}"/controller-1-hostname.yaml

talosctl patch mc \
  --talosconfig "${CONFIG_DIR}"/talosconfig \
  --nodes "${CONTROL_PLANE2}" \
  --mode reboot \
  --patch @"${PATCH_DIR}"/controller-2-hostname.yaml


# apply patches on worker nodes
talosctl patch mc \
  --talosconfig "${CONFIG_DIR}"/talosconfig \
  --mode reboot \
  --nodes "${WORKER_NODE1}" \
  --patch @"${PATCH_DIR}"/worker-1-hostname.yaml

talosctl patch mc \
  --talosconfig "${CONFIG_DIR}"/talosconfig \
  --mode reboot \
  --nodes "${WORKER_NODE2}" \
  --patch @"${PATCH_DIR}"/worker-2-hostname.yaml

talosctl patch mc \
  --talosconfig "${CONFIG_DIR}"/talosconfig \
  --mode reboot \
  --nodes "${WORKER_NODE3}" \
  --patch @"${PATCH_DIR}"/worker-3-hostname.yaml


echo "Waiting 30 sec for nodes to reboot..."
sleep 30 # need to wait for all nodes to be ready


# get talos members
talosctl get members --nodes "${CONTROL_PLANE1}" \
  --talosconfig "${CONFIG_DIR}"/talosconfig


# bootstrap cluster
talosctl bootstrap --nodes "${CONTROL_PLANE1}" \
  --talosconfig "${CONFIG_DIR}"/talosconfig


# get kubeconfig
talosctl kubeconfig \
  --nodes "${CONTROL_PLANE1}" \
  "${CONFIG_DIR}" \
  --talosconfig "${CONFIG_DIR}"/talosconfig


echo "Waiting 60 sec for kubernetes resources to be ready..."
sleep 60 # need to wait for all nodes to be ready


# get all kubernetes resources
kubectl get all \
  --kubeconfig="${CONFIG_DIR}"/kubeconfig \
  -o wide \
  -A


echo -e "\nKubernetes cluster is up and running!"