SUMMARY = "Init script for sysWORXX default setup"
LICENSE = "CLOSED"

SRC_URI = "file://init.sh"
S = "${WORKDIR}"

RDEPENDS:${PN} = " \
    e2fsprogs-e2fsck \
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
