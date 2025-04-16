FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

ROOTFS_IMAGE = "sysworxx-image-default"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit bundle

RAUC_BUNDLE_COMPATIBLE = "${MACHINE}"
RAUC_BUNDLE_FORMAT = "plain"

RAUC_KEY_FILE = "${SYSWORXX_RAUC_KEY_FILE}"
RAUC_CERT_FILE = "${SYSWORXX_RAUC_CRT_FILE}"

RAUC_SLOT_rootfs = "${ROOTFS_IMAGE}"
RAUC_SLOT_rootfs[type] = "image"
RAUC_SLOT_rootfs[fstype] = "ext4"

RAUC_BUNDLE_SLOTS = "rootfs"
