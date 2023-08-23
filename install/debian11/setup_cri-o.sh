#!/bin/bash
set -e

echo "=============SETUP CRI-O=============="
CRIO_SHORT_VERSION=`echo $CRIO_VERSION | awk 'BEGIN{FS="."} {print $1"."$2}'`
rm -rf /usr/share/keyrings/libcontainers-crio-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/libcontainers-crio-archive-keyring.gpg] https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$CRIO_SHORT_VERSION:/$CRIO_VERSION/$OS/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$CRI_VERSION.list
mkdir -p /usr/share/keyrings
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$CRIO_SHORT_VERSION:/$CRIO_VERSION/$OS/Release.key | gpg --dearmor -o /usr/share/keyrings/libcontainers-crio-archive-keyring.gpg

apt-get update
apt-get install -y cri-o

if [ ! -d /etc/crio/crio.conf.d/ ]; then
    mkdir -p /etc/crio/crio.conf.d/ 
fi

mkdir -p /var/lib/crio/

if [ $USE_CRUN == true ]; then
cat > /etc/crio/crio.conf.d/10-crun.conf <<EOF
[crio.runtime]
default_runtime = "crun"

[crio.runtime.runtimes.crun]
allowed_annotations = [
    "io.containers.trace-syscall",
]
EOF
else
cat > /etc/crio/crio.conf.d/10-runc.conf <<EOF
[crio.runtime]
default_runtime = "runc"

[crio.runtime.runtimes.runc]
runtime_type = "pod"
EOF
fi

if [ $USE_DAOCLOUD == true ]; then 
cat > /etc/crio/crio.conf.d/9-pause.conf <<EOF
[crio.image]
pause_image="k8s.m.daocloud.io/pause:3.6"
EOF
fi

systemctl daemon-reload
systemctl enable --now crio


echo "========================================"
echo ""