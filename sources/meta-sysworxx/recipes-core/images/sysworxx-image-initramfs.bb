DESCRIPTION = "Minimalistic initramfs"

IMAGE_FEATURES = ""
PACKAGE_INSTALL = "${VIRTUAL-RUNTIME_base-utils} base-passwd sysworxx-initscript"

IMAGE_FSTYPES = "${INITRAMFS_FSTYPES}"
inherit core-image

IMAGE_ROOTFS_SIZE = "8192"
IMAGE_ROOTFS_EXTRA_SPACE = "0"
