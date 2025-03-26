DESCRIPTION = "Minimalistic initramfs"

IMAGE_FEATURES = ""
PACKAGE_INSTALL = "${VIRTUAL-RUNTIME_base-utils} dosfstools base-passwd sysworxx-initscript"

IMAGE_FSTYPES = "${INITRAMFS_FSTYPES}"
inherit core-image

IMAGE_ROOTFS_SIZE = "8192"
IMAGE_ROOTFS_EXTRA_SPACE = "0"

# According to the comment in image-artifact-names.bbclass, IMAGE_NAME_SUFFIX
# should be set to empty. Leaving it as is, causes an error during do_bundle_initramfs.
# The file name given to the initramfs archive does not match the expected one,
# as long as IMAGE_NAME_SUFFIX is not empty.
# E.g.  expected: sysworxx-image-initramfs-sysworxx.cpio.gz
#       file in folder: sysworxx-image-initramfs-sysworxx.rootfs.cpio
IMAGE_NAME_SUFFIX = ""
