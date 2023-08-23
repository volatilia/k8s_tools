#!/bin/bash
set -e
echo "=============STEUP K8S TOOL============="
apt install -y kubeadm=$KUBEADM_VERSION kubectl=$KUBECTL_VERSION kubelet=$KUBELET_VERSION
systemctl enable --now kubelet 
echo "========================================"
echo ""