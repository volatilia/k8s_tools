echo "==========install minio============="
cd `dirname $0`
dir=`pwd`

kubectl create ns infrastructure
echo "installing minio ..."
kubectl apply -f $dir/pvc.yaml
kubectl create -f $dir/install.yaml

echo "wating for minio installed ..."
kubectl wait --for=condition=ready pod -l app=minio -n infrastructure --timeout=600s
echo "install minio successfully"
echo "============================================"
