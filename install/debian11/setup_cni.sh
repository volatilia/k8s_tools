#!/bin/bash
set -e

echo "===============SETUP CNI==============="
cni_url=github.com/containernetworking/plugins/releases/download/v$CNI_VERSION/cni-plugins-linux-amd64-v$CNI_VERSION.tgz
if [ $USE_DAOCLOUD == true ]; then 
echo "use daocloud donwload cni."
cni_url=files.m.daocloud.io/$cni_url
fi
wget https://$cni_url
mkdir -p /opt/cni/bin
tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v$CNI_VERSION.tgz
rm -rf ./cni-plugins-linux-amd64-v$CNI_VERSION.tgz

mkdir -p /etc/cni/net.d/
if [ $USE_CRIO == true ]; then
cat >/etc/cni/net.d/10-crio-bridge.conflist <<EOF
{
  "cniVersion": "1.0.0",
  "name": "crio",
  "plugins": [
    {
      "type": "bridge",
      "bridge": "cni0",
      "isGateway": true,
      "ipMasq": true,
      "hairpinMode": true,
      "ipam": {
        "type": "host-local",
        "routes": [
            { "dst": "0.0.0.0/0" }
        ],
        "ranges": [
            [{ "subnet": "10.85.0.0/16" }]
        ]
      }
    }
  ]
}
EOF
# else
# cat >/etc/cni/net.d/10-mynet.conflist <<EOF
# {
#     "cniVersion": "0.2.0",
#     "name": "mynet",
#     "type": "bridge",
#     "bridge": "cni0",
#     "isGateway": true,
#     "ipMasq": true,
#     "ipam": {
#         "type": "host-local",
#         "subnet": "10.22.0.0/16",
#         "routes": [
#             { "dst": "0.0.0.0/0" }
#         ]
#     }
# }
# EOF

# cat >/etc/cni/net.d/99-loopback.conflist <<EOF
# {
#     "cniVersion": "0.2.0",
#     "name": "lo",
#     "type": "loopback"
# }
# EOF
fi


echo "========================================"
echo ""