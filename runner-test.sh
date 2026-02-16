#!/usr/bin/env bash

echo "executed by gitlab runner"
cat /etc/os-release
uname -a
env | grep DOCKER