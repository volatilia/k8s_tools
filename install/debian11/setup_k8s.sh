#!/bin/bash
set -e

echo "===============SETUP K8S================"

if [ $K8S_MASTER ]; then
    IP=$(ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v 172.17.0.1 | grep -v 10.*.0.1| grep -v inet6|awk '{print $2}'|tr -d "addr:")
    hostname=`cat /etc/hostname`
cat > init.config << EOF
apiVersion: kubeadm.k8s.io/v1beta3
bootstrapTokens:
- groups:
  - system:bootstrappers:kubeadm:default-node-token
  token: abcdef.0123456789abcdef
  ttl: 24h0m0s
  usages:
  - signing
  - authentication
kind: InitConfiguration
localAPIEndpoint:
  advertiseAddress: $IP
  bindPort: 6443
nodeRegistration:
  criSocket: unix:///var/run/containerd/containerd.sock
  imagePullPolicy: IfNotPresent
  name: $hostname
  taints: null
---
apiServer:
  timeoutForControlPlane: 4m0s
apiVersion: kubeadm.k8s.io/v1beta3
certificatesDir: /etc/kubernetes/pki
clusterName: kubernetes
dns: {}
etcd:
  local:
    dataDir: /var/lib/etcd
imageRepository: registry.k8s.io
kind: ClusterConfiguration
kubernetesVersion: 1.27.0
networking:
  podSubnet: 10.244.0.0/16
  dnsDomain: cluster.local
  serviceSubnet: 10.96.0.0/12
scheduler: {}
controllerManager:
  extraArgs:
    allocate-node-cidrs: "true"
---
apiVersion: kubeproxy.config.k8s.io/v1alpha1
kind: KubeProxyConfiguration
mode: ipvs
EOF

    cat ./init.config
    kubeadm init --config ./init.config 
fi

if [ $K8S_NODE ]; then
kubeadm join $K8S_MASTER_ADDRESS $K8S_JOIN_OPT
fi

echo "========================================"
echo ""