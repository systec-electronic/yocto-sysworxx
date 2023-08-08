#!/bin/bash

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <device>"
    exit 1
fi

DEV=$1

xzcat ./build/arago-tmp-default-glibc/deploy/images/am62xx-evm/tisdk-base-image-am62xx-evm.wic.xz > "${DEV}"

sync
sleep 1

# TODO: This is at least correct for the SK-AM62 board
# see: https://software-dl.ti.com/processor-sdk-linux/esd/AM62X/latest/exports/docs/linux/Foundational_Components_Migration_Guide.html#device-types
udisksctl mount -b /dev/disk/by-label/boot
cp "/run/media/${USER}/boot/tiboot3-am62x-gp-evm.bin" \
   "/run/media/${USER}/boot/tiboot3.bin"
udisksctl unmount -b /dev/disk/by-label/boot
