#!/bin/bash
set -e

echo "============SETUP HELM============="

echo "Download containerd"
containerd_url=github.com/containerd/containerd/releases/download/v$CONTAINERD_VERSION/containerd-$CONTAINERD_VERSION-linux-amd64.tar.gz
if [ $USE_DAOCLOUD == true ]; then 
    containerd_url=files.m.daocloud.io/$containerd_url
fi