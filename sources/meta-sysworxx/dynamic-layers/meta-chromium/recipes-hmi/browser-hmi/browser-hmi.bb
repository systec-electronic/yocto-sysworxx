LICENSE = "CLOSED"
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
