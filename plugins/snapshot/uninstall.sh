git clone https://github.com/kubernetes-csi/external-snapshotter
cd external-snapshotter
git checkout tags/v6.2.2 -b release-6.2.2
kubectl kustomize client/config/crd | kubectl delete -f-
kubectl -n kube-system kustomize deploy/kubernetes/snapshot-controller | kubectl delete -f-
rm -rf ./external-snapshotter