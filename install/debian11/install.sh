#!/bin/bash
set -e

echo "WELLCOME TO USE K8S INSTALLER"
echo "The tool will help you with setup or join k8s cluster step by step. Enjoy using it."

./setup_apt_source.sh

./check_env.sh

source ./prepare_env.sh

./enabled_network_module.sh

./setup_cni.sh

./setup_crictl.sh

if [ $USE_CRUN == true ]; then
    ./setup_crun.sh
else
    ./setup_runc.sh
fi

if [ $USE_CRIO == true ]; then
    ./setup_cri-o.sh
else
    ./setup_containerd.sh
fi

./setup_k8s_tools.sh

sh ./setup_k8s.sh

echo "k8s install successful!!!!!!"
