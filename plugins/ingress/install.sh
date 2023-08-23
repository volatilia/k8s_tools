echo "==========install ingress============="
cd `dirname $0`
dir=`pwd` 

echo "installing ingress-nginx ..."
helm install ingress-nginx ingress-nginx \
  -f  $dir/values.yaml \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace

echo "waiting for ingress-nginx installed ..."
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=ingress-nginx -n ingress-nginx --timeout=600s
echo "Install ingress-nginx successfully"

 echo "===================================="