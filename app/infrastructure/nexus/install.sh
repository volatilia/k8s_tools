echo "==========install nexus============="
cd `dirname $0`
dir=`pwd`

kubectl create ns infrastructure
echo "installing nexus ..."
kubectl apply -f $dir/pvc.yaml
kubectl create -f $dir/install.yaml

echo "wating for nexus installed ..."
kubectl wait --for=condition=ready pod -l app=nexus -n infrastructure --timeout=3600s
echo "install nexus successfully"
echo "============================================"
