#!/bin/bash

mkdir -p /etc/rancher/k3s/
cp /data/shared/k3s_config.yaml /etc/rancher/k3s/config.yaml

curl -sfL https://get.k3s.io | sh -s