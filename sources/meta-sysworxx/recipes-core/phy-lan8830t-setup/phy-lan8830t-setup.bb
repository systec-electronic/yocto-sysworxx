SUMMARY = "Setup status leds of lan8830t phys"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

do_patch[noexec] = "1"
do_configure[noexec] = "1"

inherit systemd

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI = "\
    file://phy-lan8830t-setup.service \
"

do_install() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/phy-lan8830t-setup.service ${D}${systemd_unitdir}/system
}

SYSTEMD_SERVICE:${PN} = "phy-lan8830t-setup.service"
