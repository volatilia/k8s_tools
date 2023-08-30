echo "==========delete postgress operator============="
cd `dirname $0`
dir=`pwd` 

echo "delete postgres-operator ..."
kubectl delete -f $dir/operator/configmap.yaml
kubectl delete -f $dir/operator/operator-service-account-rbac.yaml
kubectl delete -f $dir/operator/postgres-operator.yaml
kubectl delete -f $dir/operator/api-service.yaml

# kubectl delete -f $dir/operator-ui/deployment.yaml
# kubectl delete -f $dir/operator-ui/ingress.yaml
# kubectl delete -f $dir/operator-ui/service.yaml
# kubectl delete -f $dir/operator-ui/ui-service-account-rbac.yaml


echo "waiting for postgres-operator deleted ..."
kubectl wait --for=delete pod -l name=postgres-operator -n postgres-operator --timeout=600s
kubectl delete ns postgres-operator
echo "delete postgres-operator successfully"

 echo "===================================="