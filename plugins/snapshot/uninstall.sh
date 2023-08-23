echo "==============uinstall volume snapshot====================="
cd `dirname $0`
dir=`pwd`

echo "deleting volume-snapshot ..."

kubectl kustomize client/config/crd | kubectl delete -f-
kubectl -n kube-system kustomize deploy/kubernetes/snapshot-controller | kubectl delete -f-

echo "wating for volume-snapshot deleted ..."
kubectl wait --for=delete pod -l app=snapshot-controller  -n kube-system --timeout=600s
echo "delete volume-snapshot successfully"
echo "==========================================================="