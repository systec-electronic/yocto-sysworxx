#!/bin/sh
# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: 2025 SYS TEC electronic AG <https://www.systec-electronic.com/>

DEV_EMMC=mmcblk0
DEV_SDCARD=mmcblk1

msg() {
    echo "$@" | sed 's/^/               initramfs: /g' >/dev/console
}

# Returns 0 on success, !=0 if device needs reboot
xfsck() {
    FSTYPE=$1
    DEV=$2

    fsck.$FSTYPE -p "${DEV}"
    RC=$?

    # see man page of fsck.ext4 (e2fsprogs / e2fsck)
    case ${RC} in
    0)
        # everything is fine
        ;;
    1)
        msg "filesystem errors on '${DEV}' have been corrected!"
        RC=0
        ;;
    2 | 3)
        msg "WARNING: errors on '${DEV}' have been corrected and reboot is needed!"
        ;;
    *)
        # the only thing we can do is reboot and hope for rootfs-fallback
        # to help at this point.
        msg "ERROR: hard errors on checking '${DEV}' occurred! (${RC})"
        ;;
    esac

    return ${RC}
}

xfsckfat() {
    xfsck fat $1
}

xfsckext4() {
    xfsck ext4 $1
}

msg "initramfs running"

mkdir -p /proc /sys /var
mount -t proc proc /proc
mount -t sysfs sysfs /sys
mount -t devtmpfs devtmpfs /dev

msg "parsing kernel cmdline"

CMDLINE=$(cat /proc/cmdline)
for arg in ${CMDLINE}; do
    optarg=$(expr "x${arg}" : 'x[^=]*=\(.*\)')
    case ${arg} in
    root=*)
        ROOT_PART=${optarg}
        ;;
    esac
done

msg "mounting filesystems"

ROOTFS_DIR="/rootfs"
mkdir -p ${ROOTFS_DIR}

ROOT_PART_NAME=$(basename "${ROOT_PART}")
BOOT_DEV=${ROOT_PART_NAME:0:-2}

# If an SD card is inserted when booting from eMMC Kernel may need some time
# until eMMC partitions are populated
sleep 2

LAST_PARTITION=$(parted -s /dev/${BOOT_DEV} print | awk '/^[ ]*[0-9]/ {print $1}' | tail -n 1)
LAST_PARTITION_LAST_SECTOR=$(parted -s /dev/${BOOT_DEV} unit s print | awk "/^ ${LAST_PARTITION}/ {print \$3}" | sed 's/s$//')
DISK_SIZE_SECTORS=$(parted -s /dev/${BOOT_DEV} unit s print | awk "/^Disk \/dev\/${BOOT_DEV}/ {print \$3}" | sed 's/s$//')
AVAILABLE_FREE_SECTORS=$((DISK_SIZE_SECTORS - LAST_PARTITION_LAST_SECTOR))
if [ "${AVAILABLE_FREE_SECTORS}" -gt 1 ]; then
    msg "resize last partition to maximum size..."
    # extended partition is always at position 3
    parted /dev/${BOOT_DEV} -s -a opt "resizepart 3 100%" || /bin/sh
    parted /dev/${BOOT_DEV} -s -a opt "resizepart ${LAST_PARTITION} 100%" || /bin/sh
    resize2fs /dev/${BOOT_DEV}p${LAST_PARTITION} || /bin/sh
    parted /dev/${BOOT_DEV} -s print
fi

if [ "$(ls /dev/${BOOT_DEV}p* | wc -l)" -ge 5 ]; then
    msg "mouting RAUC rootfs..."
    xfsckext4 /dev/${BOOT_DEV}p5 || /bin/sh
    xfsckext4 /dev/${BOOT_DEV}p6 || /bin/sh
    mount -o ro,relatime "${ROOT_PART}" "${ROOTFS_DIR}"

    msg "mounting vendor and u-boot partitions"
    xfsckfat /dev/${BOOT_DEV}p1
    xfsckfat /dev/${BOOT_DEV}p2
    mount -o ro,relatime /dev/${BOOT_DEV}p1 "${ROOTFS_DIR}/boot/vendor"
    mount -o rw,relatime /dev/${BOOT_DEV}p2 "${ROOTFS_DIR}/boot/u-boot"

    msg "mounting user partition and overlays..."
    xfsckext4 /dev/${BOOT_DEV}p7 || /bin/sh
    mount -o rw,relatime /dev/${BOOT_DEV}p7 "${ROOTFS_DIR}/home"

    R="${ROOTFS_DIR}"
    HO="${R}/home/overlays"
    mkdir -p "${HO}/etc/upper"
    mkdir -p "${HO}/etc/workdir"
    mkdir -p "${HO}/var/upper"
    mkdir -p "${HO}/var/workdir"
    mount -t overlay -o rw,relatime,lowerdir=${R}/etc,upperdir=${HO}/etc/upper,workdir=${HO}/etc/workdir overlay ${R}/etc
    mount -t overlay -o rw,relatime,lowerdir=${R}/var,upperdir=${HO}/var/upper,workdir=${HO}/var/workdir overlay ${R}/var
else
    # Fallback in case of non-RAUC image (sdimage-sysworxx.wks)
    msg "mounting rootfs..."
    xfsckfat /dev/${BOOT_DEV}p5
    mount /dev/${BOOT_DEV}p5 "${ROOTFS_DIR}"

    msg "mounting vendor and u-boot partitions"
    xfsckfat /dev/${BOOT_DEV}p1
    xfsckfat /dev/${BOOT_DEV}p2
    mount -o ro,relatime /dev/${BOOT_DEV}p1 "${ROOTFS_DIR}/boot/vendor"
    mount -o rw,relatime /dev/${BOOT_DEV}p2 "${ROOTFS_DIR}/boot/u-boot"
fi

msg "$(grep ext /proc/mounts)"
msg "$(grep overlay /proc/mounts)"
msg "switching to root..."

mount -o move /proc ${ROOTFS_DIR}/proc
mount -o move /sys ${ROOTFS_DIR}/sys
mount -o move /dev ${ROOTFS_DIR}/dev

exec switch_root -c /dev/console ${ROOTFS_DIR} /sbin/init ${CMDLINE} ||
    msg "Couldn't switch_root, dropping to shell"
/bin/sh
