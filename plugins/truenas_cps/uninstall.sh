echo "================uninstall truena csi==================="
cd `dirname $0`
dir=`pwd` 

echo "deleting truenas-csp ..."
kubectl delete -f $dir/init.yaml
helm uninstall truenas-csp -n hpe-storage
rm -rf $dir/init.yaml 

echo "waiting for truenas-csp deleted ..."
kubectl wait --for=delete pod -l app=hpe-csi-controller -n hpe-storage --timeout=600s
kubectl wait --for=delete pod -l app.kubernetes.io/name=truenas-csp -n hpe-storage --timeout=600s
kubectl wait --for=delete  pod -l app=hpe-csi-node -n hpe-storage --timeout=600s
kubectl delete ns hpe-storage
echo "delete truenas-csp successfully"
echo "========================================================"