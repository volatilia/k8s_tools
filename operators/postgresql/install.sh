echo "==========install postgresql-operator v1.10.0============="
cd `dirname $0`
dir=`pwd`
 
echo "installing postgresql-operator v1.10.0 ..."  
kubectl create ns postgres-operator
kubectl create -f $dir/operator/configmap.yaml
kubectl create -f $dir/operator/operator-service-account-rbac.yaml
kubectl create -f $dir/operator/postgres-operator.yaml
kubectl create -f $dir/operator/api-service.yaml

# kubectl create -f $dir/operator-ui/deployment.yaml
# kubectl create -f $dir/operator-ui/ingress.yaml
# kubectl create -f $dir/operator-ui/service.yaml
# kubectl create -f $dir/operator-ui/ui-service-account-rbac.yaml

echo "waiting for postgresql-operator v1.10.0 installed ..."
kubectl wait --for=condition=ready pod -l name=postgres-operator -n postgres-operator --timeout=600s
echo "Install postgresql-operator v1.10.0 successfully"

echo "==================================="