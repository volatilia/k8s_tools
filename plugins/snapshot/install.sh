echo "==========install volume snapshot============="
cd `dirname $0`
dir=`pwd`
 
echo "installing volume-snapshot v6.2.2 ..."
kubectl kustomize client/config/crd | kubectl create -f-
kubectl -n kube-system kustomize deploy/kubernetes/snapshot-controller | kubectl create -f-

echo "waiting for volume-snapshot installed ..."
kubectl wait --for=condition=ready pod -l app=snapshot-controller -n kube-system --timeout=600s
echo "Install volume-snapshot successfully"

echo "==================================="