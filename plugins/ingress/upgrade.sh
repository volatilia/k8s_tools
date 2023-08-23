script_dir=$(cd $(dirname $0);pwd)

helm upgrade ingress-nginx ingress-nginx \
  -f $script_dir/values.yaml \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace