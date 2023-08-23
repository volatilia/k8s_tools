
script_dir=$(cd $(dirname $0);pwd)
helm repo add truenas-csp https://hpe-storage.github.io/truenas-csp/
helm repo update
helm install commom-truenas-csp truenas-csp/truenas-csp --create-namespace -n hpe-storage

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

truenas_ip=$(readReq "input truenas ip:" $TRUENAS_IP)
truenas_apikey=$(readReq "input truenas api key:" $TRUENAS_APIKEY)
truenas_root=$(readReq "input truenas store root(dataset path):" $TRUENAS_ROOT)

cat > init.yaml << EOF
---
apiVersion: v1
kind: Secret
metadata:
  name: truenas-secret
  namespace: hpe-storage
stringData:
  serviceName: truenas-csp-svc
  servicePort: "8080"
  username: admin
  password: "$truenas_apikey"
  backend: $truenas_ip

---
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
  name: hpe-storageclass
provisioner: csi.hpe.com
parameters:
  csi.storage.k8s.io/controller-expand-secret-name: truenas-secret
  csi.storage.k8s.io/controller-expand-secret-namespace: hpe-storage
  csi.storage.k8s.io/controller-publish-secret-name: truenas-secret
  csi.storage.k8s.io/controller-publish-secret-namespace: hpe-storage
  csi.storage.k8s.io/node-publish-secret-name: truenas-secret
  csi.storage.k8s.io/node-publish-secret-namespace: hpe-storage
  csi.storage.k8s.io/node-stage-secret-name: truenas-secret
  csi.storage.k8s.io/node-stage-secret-namespace: hpe-storage
  csi.storage.k8s.io/provisioner-secret-name: truenas-secret
  csi.storage.k8s.io/provisioner-secret-namespace: hpe-storage
  csi.storage.k8s.io/fstype: xfs
  allowOverrides: sparse,compression,deduplication,volblocksize,sync,description
  root: $truenas_root
reclaimPolicy: Delete
allowVolumeExpansion: true
---
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshotClass
metadata:
  name: hpe-snapshot
  annotations:
    snapshot.storage.kubernetes.io/is-default-class: "true"
driver: csi.hpe.com
deletionPolicy: Delete
parameters:
  description: "Snapshot created by the HPE CSI Driver"
  csi.storage.k8s.io/snapshotter-secret-name: truenas-secret
  csi.storage.k8s.io/snapshotter-secret-namespace: hpe-storage
  csi.storage.k8s.io/snapshotter-list-secret-name: truenas-secret
  csi.storage.k8s.io/snapshotter-list-secret-namespace: hpe-storage
EOF
kubectl apply -f $script_dir/init.yaml 

rm -rf $script_dir/init.yaml 

demo= "
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-first-pvc-1
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 4Gi
  storageClassName: hpe-storageclass

---
apiVersion: v1
kind: Pod
metadata:
  name: ubuntu
  namespace: default
spec:
  containers:
    - command:
        - sh
        - -c
        - 'date >> /mnt/data/date.txt; hostname >> /mnt/data/hostname.txt; sync; sleep 5; sync; tail -f /dev/null;'
      image: ubuntu
      imagePullPolicy: Always
      name: ubuntu
      volumeMounts:
        - mountPath: /mnt/data
          name: demo-vol
  volumes:
    - name: demo-vol
      persistentVolumeClaim:
        claimName: my-first-pvc-1
"

echo "test yaml:"
echo $demo