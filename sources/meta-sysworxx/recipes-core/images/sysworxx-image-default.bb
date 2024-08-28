DESCRIPTION = "Image with sensible deefaults for SYSTEC sysWORXX modules."
LICENSE = "MIT"

# orig: debug-tweaks package-management splash
IMAGE_FEATURES += "ssh-server-openssh"
IMAGE_FEATURES:remove="package-management splash"

IMAGE_INSTALL = "\
    packagegroup-core-boot \
    packagegroup-sysworxx \
    ${CORE_IMAGE_EXTRA_INSTALL} \
    "

IMAGE_FSTYPES = "ext4 tar.gz wic.xz"

inherit core-image

DEPENDS += "linux-ti-staging"
do_rootfs[depends] += "linux-ti-staging:do_bundle_initramfs"
ROOTFS_POSTPROCESS_COMMAND += "install_initramfs; "
install_initramfs() {
    # overwrite bare kernel image with inittramfs-bundled kernel
    rm ${IMAGE_ROOTFS}/boot/${KERNEL_IMAGETYPE}*
    install -m 755 \
    ${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE}-${INITRAMFS_LINK_NAME}${KERNEL_IMAGE_BIN_EXT} \
    ${IMAGE_ROOTFS}/boot/${KERNEL_IMAGETYPE}
}
