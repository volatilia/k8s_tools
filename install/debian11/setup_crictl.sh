

echo "===============SETUP CRICTL==============="
crictl_url=github.com/kubernetes-sigs/cri-tools/releases/download/$CRICTL_VERSION/crictl-$CRICTL_VERSION-linux-amd64.tar.gz
if [ $USE_DAOCLOUD == true ]; then 
    crictl_url=files.m.daocloud.io/$crictl_url
fi
wget https://$crictl_url
tar zxvf crictl-$CRICTL_VERSION-linux-amd64.tar.gz -C /usr/local/bin
echo "crictl version:"
echo `crictl --version`
echo "========================================"
echo ""