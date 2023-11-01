#!/bin/bash

# This script installs the latest k3s package

sudo apt update
sudo apt upgrade

sudo curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644

kubectl get pods -A
