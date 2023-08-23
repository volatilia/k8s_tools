helm install ingress-nginx ingress-nginx \
  -f ./values.yaml \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace

helm upgrade ingress-nginx ingress-nginx \
  -f ./values.yaml \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace