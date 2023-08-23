echo "================uninstall flannel==================="

echo "deleting flannel ..."
helm uninstall flannel --namespace kube-flannel


echo "wating for flannel deleted..."
kubectl wait --for=delete pod -l app=flannel --namespace kube-flannel --timeout=600s
kubectl delete ns kube-flannel
echo "delete flannel successfully"
echo "====================================================="
