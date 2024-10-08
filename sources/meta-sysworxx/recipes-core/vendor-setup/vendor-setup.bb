SUMMARY = "Format and install Yocto to eMMC"
LICENSE = "CLOSED"

PACKAGE_ARCH = "${MACHINE_ARCH}"

PACKAGES = "${PN}"

RDEPENDS:${PN} += "bash"

SRC_URI = " \
    file://vendor-setup.sh \
"

do_install() {
    install -d ${D}/${base_sbindir}
    install -m 0755 ${WORKDIR}/vendor-setup.sh ${D}/${base_sbindir}/vendor-setup
}

FILES:${PN} = "\
    ${base_sbindir} \
"
