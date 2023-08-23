echo "================uninstall vsphere-cpi==================="
cd `dirname $0`
dir=`pwd`
echo "deleting vsphere-cpi ..."
helm uninstall vsphere-cpi --namespace kube-system 

echo "watingf for vsphere-cpi installed ..."
kubectl wait --for=delete pod -l app=vsphere-cpi -n kube-system --timeout=600s
echo "delete vsphere-cpi successfully"
echo "========================================================"