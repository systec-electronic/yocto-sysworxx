FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

ROOTFS_IMAGE = "sysworxx-image-default"
LICENSE = "CLOSED"

inherit bundle

RAUC_BUNDLE_COMPATIBLE = "${MACHINE}"
RAUC_BUNDLE_FORMAT = "plain"

RAUC_KEY_FILE = "${SYSWORXX_RAUC_KEY_FILE}"
RAUC_CERT_FILE = "${SYSWORXX_RAUC_CRT_FILE}"

RAUC_SLOT_rootfs = "${ROOTFS_IMAGE}"
RAUC_SLOT_rootfs[type] = "image"
RAUC_SLOT_rootfs[fstype] = "ext4"

RAUC_BUNDLE_SLOTS = "rootfs"
