#!/bin/bash
set -e

echo "===============SETUP RUNC==============="
apt install crun=$CRUN_VERSION
echo "setup crun.crun version:"
echo `crun --version`

echo "========================================"
echo ""