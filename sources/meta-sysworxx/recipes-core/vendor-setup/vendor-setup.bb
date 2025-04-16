SUMMARY = "Format and install Yocto to eMMC"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

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
