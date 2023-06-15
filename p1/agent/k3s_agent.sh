#!/bin/bash


sudo mkdir -p /etc/rancher/k3s/
sudo cp /data/shared/k3s_config.yaml /etc/rancher/k3s/config.yaml

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="agent" sh -