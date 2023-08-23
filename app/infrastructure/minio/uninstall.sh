script_dir=$(cd $(dirname $0);pwd)
kubectl delete ns infrastructure
kubectl delete -f $script_dir/pvc.yaml
kubectl delete -f $script_dir/install.yaml
