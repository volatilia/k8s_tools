script_dir=$(cd $(dirname $0);pwd)
kubectl create ns infrastructure
kubectl create -f $script_dir/pvc.yaml
kubectl create -f $script_dir/install.yaml
