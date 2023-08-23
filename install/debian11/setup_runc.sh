#!/bin/bash
set -e

echo "===============SETUP RUNC==============="
runc_url=github.com/opencontainers/runc/releases/download/v$RUNC_VERSION/runc.amd64
if [ $USE_DAOCLOUD == true ]; then 
    runc_url=files.m.daocloud.io/$runc_url
fi
wget https://$runc_url
install -m 755 runc.amd64 /usr/local/sbin/runc
rm -rf  ./runc.amd64  
echo "setup in /usr/local/sbin/runc"
echo "runc version:"
echo `runc -v`
echo "========================================"
echo ""