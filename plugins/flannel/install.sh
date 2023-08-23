
echo "==========install flannel============="
cd `dirname $0`
dir=`pwd` 

kubectl create ns kube-flannel
kubectl label --overwrite ns kube-flannel pod-security.kubernetes.io/enforce=privileged

echo "installing flannel ..."
helm install flannel flannel \
    --repo https://flannel-io.github.io/flannel/ \
    --set podCidr="10.244.0.0/16" \
    --namespace kube-flannel
echo "wating flannel installed ..."
kubectl wait --for=condition=ready pod -l app=flannel --timeout=600s
echo "install flannel successfully"

echo "====================================="
