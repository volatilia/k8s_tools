#!/bin/bash
set -e

echo "==========delete minio============="
cd `dirname $0`
dir=`pwd`

readOpt(){
    msg=$1
    default=$2 
    read -p "$msg" arg 
    echo ${arg:-$default}
}

case $(readOpt "Do you want to delete data(delete pvc)?(y|n)[n]:" n) in

    yes|y|Y|YES|Yes)
        delete_pvc=true
        ;;

    *)
        delete_pvc=false
        ;;
esac

echo "deleting minio ..."

kubectl delete -f $dir/install.yaml
if [ "$delete_pvc" = true ]; then
kubectl delete -f $dir/pvc.yaml
fi

echo "wating for minio deleted ..."
kubectl wait --for=delete pod -l app=minio -n infrastructure --timeout=600s
echo "delete minio successfully"
echo "============================================"
