LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI = " \
    file://browser-hmi.service \
"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

RDEPENDS:${PN}="cage chromium-ozone-wayland systec-logo"

inherit systemd
SYSTEMD_SERVICE:${PN} = "browser-hmi.service"
SYSTEMD_AUTO_ENABLE:${PN} = "disable"

do_install () {
    install -d ${D}${systemd_unitdir}/system
    install -m 644 ${WORKDIR}/browser-hmi.service ${D}${systemd_unitdir}/system
}
