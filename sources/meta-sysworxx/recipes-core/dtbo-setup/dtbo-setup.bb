SUMMARY = "Setup device tree overlays"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

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
