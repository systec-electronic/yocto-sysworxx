SUMMARY = "Setup device tree overlays"
LICENSE = "CLOSED"

do_patch[noexec] = "1"
do_configure[noexec] = "1"

RDEPENDS:${PN} = "bash"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI = "\
    file://dtbo-setup.sh \
"

do_install() {
    install -d ${D}${sbindir}
    install -m 0755 ${WORKDIR}/dtbo-setup.sh ${D}${sbindir}/dtbo-setup
}

FILES:${PN} += "\
    ${sbindir} \
"
