SUMMARY = "Format and install Yocto to eMMC"
LICENSE = "CLOSED"

PACKAGE_ARCH = "${MACHINE_ARCH}"

PACKAGES = "${PN}"

RDEPENDS:${PN} += "bash dosfstools e2fsprogs-mke2fs rauc parted"

SRC_URI = " \
    file://bringup.sh \
"

do_install() {
    install -d ${D}/${base_sbindir}
    install -m 0755 ${WORKDIR}/bringup.sh ${D}/${base_sbindir}/bringup
}

FILES:${PN} = "\
    ${base_sbindir} \
"
