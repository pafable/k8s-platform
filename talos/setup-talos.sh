#!/usr/bin/env bash

set -euxo pipefail

TC=$(which talosctl)
CP=$(which cp)
KUBE_DIR=${HOME}/.kube
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
CONFIG_DIR="${SCRIPT_DIR}/config"
PATCH_DIR="${SCRIPT_DIR}/patches"
CLUSTER_NAME="talos-cluster"
IMAGE="factory.talos.dev/metal-installer/ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515:v1.12.3"

# Node IPs
CONTROL_PLANE1=$1
CONTROL_PLANE2=$2
WORKER_NODE1=$3
WORKER_NODE2=$4
WORKER_NODE3=$5
DELAY=60

# Delete contents of CONFIG_DIR. Uncomment this when you're recreating the cluster
if [[ -d "${CONFIG_DIR}" ]]; then
  find "${CONFIG_DIR}" -mindepth 1 -delete
fi

# create talos secrets
${TC} gen secrets -o "${CONFIG_DIR}/secrets.yaml" --force


# create talos machine configs
${TC} gen config "${CLUSTER_NAME}" \
    https://"${CONTROL_PLANE1}":6443 \
    --output-dir "${CONFIG_DIR}" \
    --config-patch @"${PATCH_DIR}"/ntp.yaml \
    --install-image "${IMAGE}" \
    --with-secrets "${CONFIG_DIR}/secrets.yaml" \
    --force

#    --config-patch @"${PATCH_DIR}"/cni.yaml \

# apply control plane config
controlplane_ips=("${CONTROL_PLANE1}" "${CONTROL_PLANE2}")
for controlplane in "${controlplane_ips[@]}"; do

  case ${controlplane} in
    "${CONTROL_PLANE1}")
      PATCH_FILE="controller-1-hostname.yaml"
      ;;

    "${CONTROL_PLANE2}")
      PATCH_FILE="controller-2-hostname.yaml"
      ;;
  esac

  ${TC} apply-config \
    --insecure \
    --nodes "${controlplane}" \
    --file "${CONFIG_DIR}/controlplane.yaml" \
    --config-patch @"${PATCH_DIR}"/"${PATCH_FILE}" \
    --mode reboot
done


# apply worker config
worker_ips=("${WORKER_NODE1}" "${WORKER_NODE2}" "${WORKER_NODE3}")
for worker in "${worker_ips[@]}"; do

  case ${worker} in
    "${WORKER_NODE1}")
      PATCH_FILE="worker-1-hostname.yaml"
      ;;

    "${WORKER_NODE2}")
      PATCH_FILE="worker-2-hostname.yaml"
      ;;

    "${WORKER_NODE3}")
      PATCH_FILE="worker-3-hostname.yaml"
      ;;
  esac

  ${TC} apply-config \
    --insecure \
    --nodes "${worker}" \
    --file "${CONFIG_DIR}/worker.yaml" \
    --config-patch @"${PATCH_DIR}"/"${PATCH_FILE}" \
    --mode reboot
done


# configure talos endpoint
${TC} config endpoint "${CONTROL_PLANE1}" \
  --talosconfig "${CONFIG_DIR}"/talosconfig


# apply patches on controlpane nodes
echo "Waiting ${DELAY} sec for nodes to be ready..."
sleep ${DELAY} # need to wait for controlplane to be ready


# get talos members
${TC} get members --nodes "${CONTROL_PLANE1}" \
  --talosconfig "${CONFIG_DIR}"/talosconfig


# bootstrap cluster
${TC} bootstrap --nodes "${CONTROL_PLANE1}" \
  --talosconfig "${CONFIG_DIR}"/talosconfig


# get kubeconfig
${TC} kubeconfig \
  --nodes "${CONTROL_PLANE1}" \
  "${CONFIG_DIR}" \
  --talosconfig "${CONFIG_DIR}"/talosconfig


echo "Waiting ${DELAY} sec for kubernetes resources to be ready..."
sleep ${DELAY} # need to wait for all nodes to be ready


# get all kubernetes resources
${TC} get all \
  --kubeconfig="${CONFIG_DIR}"/kubeconfig \
  -o wide \
  -A


echo "Waiting ${DELAY} sec for nodes to reboot and kubernetes resources to be ready"
sleep ${DELAY}


# get nodes
${TC} get nodes \
  --kubeconfig="${CONFIG_DIR}"/kubeconfig


echo -e "\nKubernetes cluster is up and running!"

# add kubeconfig in .kube dir
if [[ -d ${KUBE_DIR} ]]; then
	${CP} "${CONFIG_DIR}"/kubeconfig "${KUBE_DIR}"/config
fi
