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

udisksctl mount -b /dev/disk/by-label/root
mp_root=$(udisksctl info -b /dev/disk/by-label/root | grep MountPoint | awk '{ print $2} ')
sudo mkdir -p "${mp_root}/opt/image"
sudo cp -L "${DEPLOY_DIR}/tiboot3-am62x-gp-evm.bin" "${mp_root}/opt/image/tiboot3.bin"
sudo cp -L "${DEPLOY_DIR}/tispl.bin" "${mp_root}/opt/image/"
sudo cp -L "${DEPLOY_DIR}/u-boot.img" "${mp_root}/opt/image/"
sudo cp -L "${DEPLOY_DIR}/sysworxx-image-default-sysworxx.rootfs.tar.gz" "${mp_root}/opt/image/"
udisksctl unmount -b /dev/disk/by-label/root
