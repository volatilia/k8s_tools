#!/bin/bash
set -e

echo "============SETUP CONTAINERD============="
echo "Download containerd"
containerd_url=github.com/containerd/containerd/releases/download/v$CONTAINERD_VERSION/containerd-$CONTAINERD_VERSION-linux-amd64.tar.gz
if [ $USE_DAOCLOUD == true ]; then 
    containerd_url=files.m.daocloud.io/$containerd_url
fi

wget https://$containerd_url
tar Cxzvf /usr/local containerd-$CONTAINERD_VERSION-linux-amd64.tar.gz
rm -rf ./containerd-$CONTAINERD_VERSION-linux-amd64.tar.gz
echo "setup in /usr/local"
echo "config containerd"
 

# if [ $USE_CRUN == true ]; then
#     sed -i 's/runtime = "runc"/runtime = "crun"/g' /etc/containerd/config.toml 
#     sed -i 's/plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc/plugins."io.containerd.grpc.v1.cri".containerd.runtimes.crun/g' /etc/containerd/config.toml 
#     sed -i 's/default_runtime_name = "runc"/default_runtime_name = "crun"/g' /etc/containerd/config.toml 
#     sed -i 's/BinaryName = ""/BinaryName = "crun"/g' /etc/containerd/config.toml
# fi

config_path='/etc/containerd/config.toml'
systemdCgroup=true
registry_config_path=""

if [ $USR_IMAGES_MIRROR ]; then
registry_config_path=/etc/containerd/certs.d
mkdir -p $registry_config_path
fi


if [ -n $IMAGE_MIRROR_K8S ]; then
mkdir -p /etc/containerd/certs.d/registry.k8s.io/
cat > /etc/containerd/certs.d/registry.k8s.io/hosts.toml <<EOF
server = "https://registry.k8s.io"

[host."https://$IMAGE_MIRROR_K8S"]
   capabilities = ["pull", "resolve"]
EOF
fi

if [ -n $IMAGE_MIRROR_K8S_GCR ]; then
mkdir -p /etc/containerd/certs.d/k8s.gcr.io/
cat > /etc/containerd/certs.d/k8s.gcr.io/hosts.toml <<EOF
server = "https://k8s.gcr.io"

[host."https://$IMAGE_MIRROR_K8S_GCR"]
   capabilities = ["pull", "resolve"]
EOF
fi

if [ -n $IMAGE_MIRROR_GCR ]; then
mkdir -p /etc/containerd/certs.d/gcr.io/
cat > /etc/containerd/certs.d/gcr.io/hosts.toml <<EOF
server = "https://gcr.io"

[host."https://$IMAGE_MIRROR_GCR"]
   capabilities = ["pull", "resolve"]
EOF
fi

if [ -n $IMAGE_MIRROR_GHCR ]; then
mkdir -p /etc/containerd/certs.d/ghcr.io/
cat > /etc/containerd/certs.d/ghcr.io/hosts.toml <<EOF
server = "https://ghcr.io"

[host."https://$IMAGE_MIRROR_GHCR"]
   capabilities = ["pull", "resolve"]
EOF
fi

if [ -n $IMAGE_MIRROR_MCR ]; then
mkdir -p /etc/containerd/certs.d/mcr.microsoft.com/
cat > /etc/containerd/certs.d/mcr.microsoft.com/hosts.toml <<EOF
server = "https://mcr.microsoft.com"

[host."https://$IMAGE_MIRROR_MCR"]
   capabilities = ["pull", "resolve"]
EOF
fi

if [ -n $IMAGE_MIRROR_NVCR ]; then
mkdir -p /etc/containerd/certs.d/nvcr.io/
cat > /etc/containerd/certs.d/nvcr.ioo/hosts.toml <<EOF
server = "https://nvcr.io"

[host."https://$IMAGE_MIRROR_NVCR"]
   capabilities = ["pull", "resolve"]
EOF
fi

if [ -n $IMAGE_MIRROR_QUAY ]; then
mkdir -p /etc/containerd/certs.d/quay.io/
cat > /etc/containerd/certs.d/quay.io/hosts.toml <<EOF
server = "https://quay.io"

[host."https://$IMAGE_MIRROR_QUAY"]
   capabilities = ["pull", "resolve"]
EOF
fi

if [ -n $IMAGE_MIRROR_DOCKERHUB ]; then
mkdir -p /etc/containerd/certs.d/docker.io/
cat > /etc/containerd/certs.d/docker.io/hosts.toml <<EOF
server = "https://docker.io"

[host."https://$IMAGE_MIRROR_DOCKERHUB"]
  capabilities = ["pull", "resolve"]
EOF
fi

cat > ${config_path} <<EOF
version = 2

[plugins."io.containerd.grpc.v1.cri".registry]
  config_path = "${registry_config_path}"
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
  SystemdCgroup = ${systemdCgroup}
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
  runtime_type = "io.containerd.runc.v2"
EOF
chmod 644 "${config_path}"


echo "------containerd config------"
cat /etc/containerd/config.toml
echo "-----------------------------"

containerd_service_url=github.com/containerd/containerd/raw/main/containerd.service
if [ $USE_DAOCLOUD ]; then 
    containerd_service_url=files.m.daocloud.io/$containerd_service_url
fi
wget https://$containerd_service_url
mv containerd.service /lib/systemd/system/containerd.service

systemctl daemon-reload
systemctl enable --now containerd 
systemctl restart containerd

echo "========================================"
echo ""

