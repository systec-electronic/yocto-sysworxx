SUMMARY = "Rename CAN0 and CAN1 to reflect order of chassis"
LICENSE = "CLOSED"

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
