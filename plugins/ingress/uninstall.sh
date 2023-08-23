echo "=============uninstall ingress======================"

echo "deleting ingress-nginx ..."
helm uninstall ingress-nginx --namespace ingress-nginx 


echo "waiting for ingress-nginx deleted ..."
kubectl wait --for=delete pod -l app.kubernetes.io/name=ingress-nginx -n ingress-nginx --timeout=600s
kubectl delete ns ingress-nginx 
echo "delete ingress-nginx successfully"
echo "===================================================="