#!/usr/bin/env bash

set -euxo pipefail


SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
BASE_DIR="$(cd "$SCRIPT_DIR/../../.." && pwd)"
CONFIG_DIR="${BASE_DIR}/talos/config"
CLUSTER_NAME="talos-cluster"
IMAGE="factory.talos.dev/installer/ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515:v1.11.5"

# Node IPs
CONTROL_PLANE1=$1
WORKER_NODE1=$2
WORKER_NODE2=$3


# create talos secrets
talosctl gen secrets -o "${CONFIG_DIR}/secrets.yaml" --force


# create talos configs
talosctl gen config "${CLUSTER_NAME}" \
    https://"${CONTROL_PLANE1}":6443 \
    --output-dir "${CONFIG_DIR}" \
    --install-image "${IMAGE}" \
    --with-secrets "${CONFIG_DIR}/secrets.yaml" \
    --force


# apply control plane config
talosctl apply-config \
    --insecure \
    --nodes "${CONTROL_PLANE1}" \
    --file "${CONFIG_DIR}/controlplane.yaml"


# apply worker config
talosctl apply-config \
    --insecure \
    --nodes "${WORKER_NODE1}" \
    --file "${CONFIG_DIR}/worker.yaml"

talosctl apply-config \
    --insecure \
    --nodes "${WORKER_NODE2}" \
    --file "${CONFIG_DIR}/worker.yaml"


# export talos config
export TALOSCONFIG="${CONFIG_DIR}/talosconfig"


# configure talos endpoint
talosctl config endpoint "${CONTROL_PLANE1}"


# get talos members
sleep 45 # need to wait for controlplane to be ready
talosctl get members --nodes "${CONTROL_PLANE1}"


# bootstrap cluster
talosctl bootstrap --nodes "${CONTROL_PLANE1}"


# get kubeconfig
talosctl kubeconfig \
  --nodes "${CONTROL_PLANE1}" \
  "${CONFIG_DIR}"