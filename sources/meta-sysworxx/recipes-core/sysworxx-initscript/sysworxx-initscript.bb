SUMMARY = "Init script for sysWORXX default setup"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://init.sh"
S = "${WORKDIR}"

RDEPENDS:${PN} = " \
    e2fsprogs-e2fsck \
    e2fsprogs-resize2fs \
    parted \
"

do_install() {
    install -m 0755 ${WORKDIR}/init.sh ${D}/init

    # Create device nodes expected by some kernels in initramfs
    # before even executing /init.
    install -d ${D}/dev
    mknod -m 622 ${D}/dev/console c 5 1
}

inherit allarch

FILES:${PN} += "\
    /init \
    /dev/console \
"
