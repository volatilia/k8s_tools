echo "==========install vsphere cpi============="
cd `dirname $0`
dir=`pwd`
readReq(){
    msg=$1
    if [ "$2" == "" ]; then
        until [ ! $arg == "" ]
        do
            read -p "$msg" arg
        done
    else
        $arg=$2
    fi
    echo ${arg}
}

vcenter_ip=$(readReq "please input vcenter ip:")
vcenter_usr=$(readReq "please input vcenter user:")
vcenter_pwd=$(readReq "please input vcenter password:")
vcenter_datacenter=$(readReq "please input vcenter datacenter:")


echo "installing vsphere-cpi ..."
helm install vsphere-cpi vsphere-cpi \
 --repo https://kubernetes.github.io/cloud-provider-vsphere \
 --namespace kube-system \
 --set config.enabled=true \
 --set config.vcenter=$vcenter_ip \
 --set config.username=$vcenter_usr \
 --set config.password=$vcenter_pwd \
 --set config.datacenter=$vcenter_datacenter

echo "wating for vsphere-cpi installed ..."
kubectl wait --for=condition=ready pod -l app=vsphere-cpi  -n kube-system --timeout=600s
echo "install vsphere-cpi successfully"

 echo "==================================="
