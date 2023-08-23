#!/bin/bash
set -e

echo "============SETUP APT SOURCE============"
read -p "Please select apt source repo.opetions:tsinghua|ustc|aliyun(default:not set and use google kubenetes source list)" arg

echo "Beigin setup apt source."
apt_source=$arg
rm -rf /etc/apt/sources.list.d/**

case $apt_source in

"ustc")
cat > /etc/apt/sources.list <<EOF
deb http://mirrors.ustc.edu.cn/debian/ bullseye main
deb-src http://mirrors.ustc.edu.cn/debian/ bullseye main

deb http://security.debian.org/debian-security bullseye-security main
deb-src http://security.debian.org/debian-security bullseye-security main

# bullseye-updates, to get updates before a point release is made;
# see https://www.debian.org/doc/manuals/debian-reference/ch02.en.html#_updates_and_backports
deb http://mirrors.ustc.edu.cn/debian/ bullseye-updates main
deb-src http://mirrors.ustc.edu.cn/debian/ bullseye-updates main
EOF
;;

"tsinghua")
cat > /etc/apt/sources.list <<EOF
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free

deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free

deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free

deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free
deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free

deb https://security.debian.org/debian-security bullseye-security main contrib non-free
deb-src https://security.debian.org/debian-security bullseye-security main contrib non-free
EOF
;;

"aliyun")
cat > /etc/apt/sources.list <<EOF
deb https://mirrors.aliyun.com/debian/ bullseye main non-free contrib
deb-src https://mirrors.aliyun.com/debian/ bullseye main non-free contrib
deb https://mirrors.aliyun.com/debian-security/ bullseye-security main
deb-src https://mirrors.aliyun.com/debian-security/ bullseye-security main
deb https://mirrors.aliyun.com/debian/ bullseye-updates main non-free contrib
deb-src https://mirrors.aliyun.com/debian/ bullseye-updates main non-free contrib
deb https://mirrors.aliyun.com/debian/ bullseye-backports main non-free contrib
deb-src https://mirrors.aliyun.com/debian/ bullseye-backports main non-free contrib
EOF
;;

"")
echo "Use system default apt source repo."
;;
esac

apt update
echo "Setup apt source successfully"
echo "source list (/etc/apt/sources.list):"
cat /etc/apt/sources.list
apt-get install -y apt-transport-https ca-certificates curl gnupg

echo "Begin setup kubenetes apt source."
case $apt_source in
"ustc")
curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add - 
cat >/etc/apt/sources.list.d/kubernetes.list <<EOF
deb https://mirrors.ustc.edu.cn/kubernetes/apt kubernetes-xenial main
EOF
;;
"tsinghua")
curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add - 
cat >/etc/apt/sources.list.d/kubernetes.list <<EOF
deb https://mirrors.tuna.tsinghua.edu.cn/kubernetes/apt/ kubernetes-xenial main
EOF
;;
"aliyun")
curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add - 
cat >/etc/apt/sources.list.d/kubernetes.list <<EOF
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF
;;
"")
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg 
cat >/etc/apt/sources.list.d/kubernetes.list <<EOF
deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main"
EOF
;;
esac

apt update
echo "Setup kubenetes apt source successfully."
echo "kubenetes source list (/etc/apt/sources.list.d/kubernetes.list):"
cat /etc/apt/sources.list.d/kubernetes.list


apt -y install selinux-utils git

curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | tee /usr/share/keyrings/helm.gpg > /dev/null
apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list
apt-get update
apt-get install helm

echo "========================================"
echo ""