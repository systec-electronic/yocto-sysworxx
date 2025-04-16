SUMMARY = "Rename CAN0 and CAN1 to reflect order of chassis"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

do_patch[noexec] = "1"
do_configure[noexec] = "1"

inherit systemd

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI = "\
    file://can-setup.service \
"

do_install() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/can-setup.service ${D}${systemd_unitdir}/system
}

SYSTEMD_SERVICE:${PN} = "can-setup.service"
