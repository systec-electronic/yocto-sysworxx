#!/bin/sh

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
case ${ROOT_PART_NAME} in
${DEV_SDCARD}*)
    msg "mounting SD card partitions..."
    mount /dev/${DEV_SDCARD}p3 "${ROOTFS_DIR}"

    msg "mounting vendor and u-boot partitions"
    xfsckfat /dev/${DEV_SDCARD}p1
    xfsckfat /dev/${DEV_SDCARD}p2
    mount /dev/${DEV_SDCARD}p1 "${ROOTFS_DIR}/boot/vendor"
    mount /dev/${DEV_SDCARD}p2 "${ROOTFS_DIR}/boot/u-boot"
    ;;
${DEV_EMMC}*)
    # If an SD card is inserted when booting from eMMC Kernel may need some time
    # until eMMC partitions are populated
    sleep 2

    if [ "$(ls /dev/${DEV_EMMC}p* | wc -l)" -eq 5 ]; then
        msg "mounting eMMC partitions..."
        xfsckext4 /dev/${DEV_EMMC}p3 || /bin/sh
        xfsckext4 /dev/${DEV_EMMC}p4 || /bin/sh
        mount -o ro,relatime "${ROOT_PART}" "${ROOTFS_DIR}" # mount p1 or p2, depending on

        msg "mounting vendor and u-boot partitions"
        xfsckfat /dev/${DEV_EMMC}p1
        xfsckfat /dev/${DEV_EMMC}p2
        mount /dev/${DEV_EMMC}p1 "${ROOTFS_DIR}/boot/vendor"
        mount /dev/${DEV_EMMC}p2 "${ROOTFS_DIR}/boot/u-boot"

        msg "mounting user part and overlays..."
        xfsckext4 /dev/${DEV_EMMC}p5 || /bin/sh
        mount -o rw,relatime /dev/${DEV_EMMC}p5 "${ROOTFS_DIR}/home"

        R="${ROOTFS_DIR}"
        HO="${R}/home/overlays"
        mkdir -p "${HO}/etc/upper"
        mkdir -p "${HO}/etc/workdir"
        mkdir -p "${HO}/var/upper"
        mkdir -p "${HO}/var/workdir"
        mount -t overlay -o rw,relatime,lowerdir=${R}/etc,upperdir=${HO}/etc/upper,workdir=${HO}/etc/workdir overlay ${R}/etc
        mount -t overlay -o rw,relatime,lowerdir=${R}/var,upperdir=${HO}/var/upper,workdir=${HO}/var/workdir overlay ${R}/var
    else
        msg "ERROR: unexpected partition layout. root-fs will not be mounted."
        exec /bin/sh
    fi
    ;;
*)
    msg "ERROR: invalid root device in kernel command line! (root=${ROOT_PART_NAME})"
    exec /bin/sh
    ;;
esac

msg "$(grep ext /proc/mounts)"
msg "$(grep overlay /proc/mounts)"
msg "switching to root..."

mount -o move /proc ${ROOTFS_DIR}/proc
mount -o move /sys ${ROOTFS_DIR}/sys
mount -o move /dev ${ROOTFS_DIR}/dev

exec switch_root -c /dev/console ${ROOTFS_DIR} /sbin/init ${CMDLINE} ||
    msg "Couldn't switch_root, dropping to shell"
/bin/sh
