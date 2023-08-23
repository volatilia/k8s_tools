#!/bin/bash
set -e

source ./common_fun.sh

echo "===============PREPARE ENV=============="
export OS="Debian_11"

export KUBELET_VERSION="1.27.3-00"
export KUBEADM_VERSION="1.27.3-00"
export KUBECTL_VERSION="1.27.3-00"

export CRICTL_VERSION="v1.27.1"

export RUNC_VERSION="1.1.7"
export CRUN_VERSION="0.17+dfsg-1+deb11u1"

export CNI_VERSION="1.3.0"

export CONTAINERD_VERSION="1.7.2"
export CRIO_VERSION="1.27.0"

if [ "$USE_HTTP_PROXY" == "" ]; then
    case $(readOpt "Do you want to use http proxy(y|n)[n]:" n) in
        yes|y|Y|YES|Yes)
            export USE_HTTP_PROXY="yes"
            ;;

        *)
            ;;
    esac
fi


if [ "$USE_HTTP_PROXY" == "yes" ]; then
    export HTTP_PROXY_URL=$(readReq "Please input http proxy url::" )
fi

if [ "$HTTP_PROXY_URL" != "" ]; then
    export http_proxy=$HTTP_PROXY_URL
    export https_proxy=$HTTP_PROXY_URL
    export no_proxy="127.0.0.1,localhost,$no_proxy"
fi


case $(readOpt "Do you want to use DaoClould to acceleration download binary file(y|n)[n]:" n) in

    yes|y|Y|YES|Yes)
        export USE_DAOCLOUD=true
        ;;

    *)
        export USE_DAOCLOUD=false
        ;;
esac


case $(readOpt "Please select OCI runtime(crun|runc)[runc]" runc) in

    crun)
        export OCI_RUNTIME="crun"
        ;;

    runc)
        export OCI_RUNTIME="runc"
        ;;

    *)
        ;; 
esac

export USE_CRIO=false
export USE_CRUN=false
if [ "$OCI_RUNTIME" == "crun" ]; then
    export USE_CRUN=true
fi
export USE_CRIO=false
case $(readOpt "Please select CRI(contianerd|cri-o)[containerd]:" contianerd) in

    contianerd)
        export CRI=contianerd
        ;;

    cri-o)
        export CRI=cri-o
        export USE_CRIO=true
        ;;

    *)
        ;; 
esac

export USR_IMAGES_MIRROR=false
case $(readOpt "Please select images mirror(daocloud|aliyun):") in
    daocloud)
        export IMAGE_MIRROR_K8S=k8s.m.daocloud.io
        export IMAGE_MIRROR_K8S_GCR=k8s-gcr.m.daocloud.io
        export IMAGE_MIRROR_GCR=gcr.m.daocloud.io
        export IMAGE_MIRROR_GHCR=ghcr.m.daocloud.io
        export IMAGE_MIRROR_MCR=mcr.m.daocloud.io
        export IMAGE_MIRROR_NVCR=nvcr.m.daocloud.io
        export IMAGE_MIRROR_QUAY=quay.m.daocloud.io
        export IMAGE_MIRROR_DOCKERHUB=docker.m.daocloud.io
        export USR_IMAGES_MIRROR=true
        ;;

    aliyun)
        #export IMAGE_MIRROR_K8S=registry.cn-hangzhou.aliyuncs.com/google_containers
        export IMAGE_MIRROR_K8S=k8s.m.daocloud.io
        export IMAGE_MIRROR_DOCKERHUB=registry.cn-hangzhou.aliyuncs.com
        export USR_IMAGES_MIRROR=true
        ;;

    *)
        ;; 
esac

case $(readOpt "You are init k8s master or node?(master|node)" master) in
    master)
        export K8S_INIT_OPT=""
        export K8S_MASTER=true
        ;;

    node)
        export K8S_MASTER_ADDRESS=$(readReq "Please input k8s master(host and port):" )

        token=`readReq "Please input k8s master token:" `
 
        ca_hash=`readReq "Please input k8s master token CA hash:" `
        export K8S_JOIN_OPT="--token $token --discovery-token-ca-cert-hash $ca_hash $K8S_JOIN_OPT"
        export K8S_NODE=true
        ;;

    *)
        ;; 
esac

# mkdir -p /etc/containerd/certs.d/registry.k8s.io/
# cat > /etc/containerd/certs.d/registry.k8s.io/hosts.toml <<EOF
# server = https://registry.k8s.io

# [host."https://k8s.m.daocloud.io"]
#   capabilities = ["pull", "resolve"]
# EOF
# ctr --debug images pull --local false registry.k8s.io/pause:3.8


# cat > /etc/containerd/certs.d/docker.io/hosts.toml <<EOF
# server = https://docker.io 

# [host."https://registry.cn-hangzhou.aliyuncs.com"]
#   capabilities = ["pull", "resolve"]
# EOF


echo "ENV:"
echo "----"
printenv


echo "========================================"
echo ""




