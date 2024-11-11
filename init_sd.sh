#!/bin/bash

set -e

if [ -z "$1" ]; then
   echo "Usage: $0 <BLOCK DEVICE> [DEPLOY DIR]"
   exit 1
fi

DEV=$1
DEPLOY_DIR=${2:-./build/deploy-ti/images/sysworxx}

xzcat "${DEPLOY_DIR}/sysworxx-image-default-sysworxx.rootfs.wic.xz" >"${DEV}"

sync
sleep 1

udisksctl mount -b /dev/disk/by-label/boot
cp "/run/media/${USER}/boot/tiboot3-am62x-gp-evm.bin" \
   "/run/media/${USER}/boot/tiboot3.bin"
udisksctl unmount -b /dev/disk/by-label/boot

udisksctl mount -b /dev/disk/by-label/root
sudo mkdir -p "/run/media/${USER}/root/opt/image"
sudo cp -L ${DEPLOY_DIR}/tiboot3-am62x-gp-evm.bin "/run/media/${USER}/root/opt/image/tiboot3.bin"
sudo cp -L ${DEPLOY_DIR}/tispl.bin "/run/media/${USER}/root/opt/image/"
sudo cp -L ${DEPLOY_DIR}/u-boot.img "/run/media/${USER}/root/opt/image/"
sudo cp -L ${DEPLOY_DIR}/sysworxx-image-default-sysworxx.rootfs.tar.gz "/run/media/${USER}/root/opt/image/"
udisksctl unmount -b /dev/disk/by-label/root
