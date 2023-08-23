#!/bin/bash
set -e
echo "========ENABLE NETWORK MODULES========="
cat <<EOF | tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
sysctl --system


#ipvs setup
apt-get install -y ipset ipvsadm
cat > /etc/modules-load.d/ipvs.modules <<EOF
modprobe -- ip_vs
modprobe -- ip_vs_rr
modprobe -- ip_vs_wrr
modprobe -- ip_vs_sh
modprobe -- nf_conntrack
EOF

source /etc/modules-load.d/ipvs.modules 

echo "Netework config sucessful."

echo "========================================"
echo ""