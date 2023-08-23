cd `dirname $0`
dir=`pwd` 

$dir/flannel/install.sh
$dir/vsphere-cpi/install.sh 
$dir/snapshot/install.sh
$dir/truenas_cps/install.sh 
$dir/ingress/install.sh

