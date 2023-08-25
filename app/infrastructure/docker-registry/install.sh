echo "==========install docker-registry============="
cd `dirname $0`
dir=`pwd`

kubectl create ns infrastructure
echo "installing docker-registry ..."
kubectl apply -f $dir/pvc.yaml
kubectl create -f $dir/install.yaml

echo "wating docker-registry installed ..."
kubectl wait --for=condition=ready pod -l app=registry -n infrastructure --timeout=600s
echo "install docker-registry successfully"
echo "============================================"
