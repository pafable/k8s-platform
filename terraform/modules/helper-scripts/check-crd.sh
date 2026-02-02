#!/usr/bin/env bash
# This script checks if a CRD is installed in the cluster.
# CRD must be passed in as a parameter in json format.
# Example: {"crd": "gatewayclass"}

eval "$(jq -r '@sh "CRD=\(.crd)"')"
COUNT=$(kubectl get crd 2>/dev/null | grep -ci "$CRD")

if [ "$COUNT" -eq 1 ]; then
  STATUS="true"
else
  STATUS="false"
fi

echo "{\"installed\": \"$STATUS\"}"