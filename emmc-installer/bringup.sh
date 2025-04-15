#!/bin/bash

#***************************************************************************#
#                                                                           #
#  SYSTEC electronic AG, D-08468 Heinsdorfergrund, Am Windrad 2             #
#  www.systec-electronic.com                                                #
#                                                                           #
#  File:         bringup.sh                                                 #
#  Description:  Script for initial installation to eMMC                    #
#                                                                           #
#                                                                           #
#****************************************************************************

# abort on errors
set -e

EMMC_BOOT0_BLK=mmcblk0boot0
EMMC_DEVICE=/dev/mmcblk0
BRINGUP_SOURCE_DIR=${1}
PARTITIONS_START_MiB=1
VENDOR_SIZE_MiB=4
RAUC_ENV_SIZE_MiB=4
ROOTFS_SIZE_MiB=2560

VENDOR_START=${PARTITIONS_START_MiB}
VENDOR_END=$((VENDOR_START + VENDOR_SIZE_MiB))
UBOOT_ENV_START=${VENDOR_END}
UBOOT_ENV_END=$((UBOOT_ENV_START + RAUC_ENV_SIZE_MiB))
EXTENDED_START=${UBOOT_ENV_END}
ROOTFS_0_START=$((EXTENDED_START + 1))
ROOTFS_0_END=$((ROOTFS_0_START + ROOTFS_SIZE_MiB))
ROOTFS_1_START=$((ROOTFS_0_END + 1))
ROOTFS_1_END=$((ROOTFS_1_START + ROOTFS_SIZE_MiB))
USER_START=$((ROOTFS_1_END + 1))
USER_END="100%" # use remaining eMMC space for user part

function unlock_dev() {
    local BLK_DEV=$1
    echo 0 >"/sys/block/${BLK_DEV}/force_ro"
}

function lock_dev() {
    local BLK_DEV=$1
    echo 1 >"/sys/block/${BLK_DEV}/force_ro"
}

if mount | grep -q -e "${EMMC_DEVICE}p[56]"; then
    echo Installation can only be performed when booted from SD card!
    exit 1
fi

unlock_dev ${EMMC_BOOT0_BLK}
dd if="${BRINGUP_SOURCE_DIR}/tiboot3-am62x-gp-evm.bin" of=${EMMC_DEVICE}boot0 seek=0
dd if="${BRINGUP_SOURCE_DIR}/tispl.bin" of=${EMMC_DEVICE}boot0 seek=1024
dd if="${BRINGUP_SOURCE_DIR}/u-boot.img" of=${EMMC_DEVICE}boot0 seek=5120
lock_dev ${EMMC_BOOT0_BLK}

umount ${EMMC_DEVICE}p* || true

# create partition table
parted -s ${EMMC_DEVICE} \
    unit MiB \
    mktable msdos \
    mkpart primary fat32 ${VENDOR_START} ${VENDOR_END} \
    mkpart primary fat32 ${UBOOT_ENV_START} ${UBOOT_ENV_END} \
    mkpart extended ${EXTENDED_START} 100% \
    mkpart logical ext4 ${ROOTFS_0_START} ${ROOTFS_0_END} \
    mkpart logical ext4 ${ROOTFS_1_START} ${ROOTFS_1_END} \
    mkpart logical ext4 ${USER_START} ${USER_END} \
    print

# reload partition table
partprobe ${EMMC_DEVICE}

# Wait a bit to have symlinks being created
sleep 1

# format partitions
mkfs.vfat /dev/disk/by-path/platform-fa10000.mmc-part1 -n vendor
mkfs.vfat /dev/disk/by-path/platform-fa10000.mmc-part2 -n uboot-env
mkfs.ext4 /dev/disk/by-path/platform-fa10000.mmc-part7 -q -F -L user

# install rootfs using rauc
rauc --mount /tmp -c "${BRINGUP_SOURCE_DIR}/system.conf" write-slot rootfs.0 "${BRINGUP_SOURCE_DIR}/sysworxx-image-default-sysworxx.rootfs.tar.gz"
rauc --mount /tmp -c "${BRINGUP_SOURCE_DIR}/system.conf" write-slot rootfs.1 "${BRINGUP_SOURCE_DIR}/sysworxx-image-default-sysworxx.rootfs.tar.gz"

sync

exit 0
