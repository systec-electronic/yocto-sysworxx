DESCRIPTION = "Image with sensible deefaults for SYSTEC sysWORXX modules."

# orig: debug-tweaks package-management splash
IMAGE_FEATURES += "ssh-server-openssh"
IMAGE_FEATURES:remove="package-management splash"

IMAGE_INSTALL = "\
    packagegroup-core-boot \
    packagegroup-sysworxx \
    ${CORE_IMAGE_EXTRA_INSTALL} \
    "

inherit core-image
