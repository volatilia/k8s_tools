#!/bin/bash
set -e
echo "==============ENV CHECK==============="

check_status=true
selinux_status=`getenforce`
if [ "$selinux_status" != 'Disabled' ]; then
check_status=false
echo "issue: Not close selinux"
echo "Please disbaled Seliunx."
fi

swap_size=`grep '^SwapTotal:' /proc/meminfo | awk '/[0-9]+/ { print $2 }'`
if [ "$swap_size" -gt 0 ]; then
check_status=false
echo "issue: Not close swap"
echo "Please set swap to 0."
echo "please execute command(systemctl --type swap) to view swap disk uuid and edit /etc/fstab to comment the uuid row, and reboot."
fi

if [ "$check_status" == 'false' ]; then
echo "ENV has some error. Please fix issues."
exit 1
fi
echo "ENV is ready for install k8s."


echo "========================================"
echo ""
