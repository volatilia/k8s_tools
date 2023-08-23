govc tags.category.create -d "Kubernetes region" k8s-region
govc tags.category.create -d "Kubernetes zone" k8s-zone
govc tags.create -d "Kubernetes Region X1" -c k8s-region k8s-region-x1 
govc tags.create -d "Kubernetes Zone X1-A" -c k8s-zone k8s-zone-x1-a

please assign tag to target datacenter.

and instll vsphere-cpi.