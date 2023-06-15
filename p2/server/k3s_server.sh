#!/bin/bash

mkdir -p /etc/rancher/k3s/
cp /data/shared/k3s_config.yaml /etc/rancher/k3s/config.yaml

curl -sfL https://get.k3s.io | sh -s


while [ ! -e "/var/lib/rancher/k3s/server/manifests/" ]; do sleep 1; done

kubectl apply -f /data/shared/volume-apache.yaml
kubectl apply -f /data/shared/volume-wordpress.yaml
kubectl apply -f /data/shared/volume-nginx.yaml
kubectl apply -f /data/shared/ingress-config.yaml

