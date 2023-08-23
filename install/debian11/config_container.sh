


config_path='/etc/containerd/config.toml'
systemdCgroup=true
cat > ${config_path} <<EOF
version = 2

[plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"]
  endpoint = ["https://${IMAGE_MIRROR_DOCKERHUB:-docker.io}"]
[plugins."io.containerd.grpc.v1.cri".registry.mirrors."registry.k8s.io"]
  endpoint = ["https://${IMAGE_MIRROR_K8S:-registry.k8s.io}"]
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
  SystemdCgroup = ${systemdCgroup}
[plugins."io.containerd.grpc.v1.cri"]
sandbox_image= "${IMAGE_MIRROR_K8S:-registry.k8s.io}/pause:3.8"
EOF
chmod 644 "${config_path}"

