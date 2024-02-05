#!/bin/bash

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <device>"
    exit 1
fi

DEV=$1

xzcat ./build/deploy-ti/images/ctr-700/sysworxx-image-default-ctr-700.wic.xz > "${DEV}"

sync
sleep 1

udisksctl mount -b /dev/disk/by-label/boot
cp "/run/media/${USER}/boot/tiboot3-am62x-gp-evm.bin" \
   "/run/media/${USER}/boot/tiboot3.bin"
udisksctl unmount -b /dev/disk/by-label/boot
