cd `dirname $0`
dir=`pwd`
echo "$dir"
$dir/ingress/uninstall.sh 
$dir/snapshot/uninstall.sh
$dir/truenas_cps/uninstall.sh
$dir/vsphere-cpi/uninstall.sh 
$dir/flannel/uninstall.sh
