FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
    file://fstrim.timer \
    file://fstrim.service \
"

do_install:append() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/fstrim.service ${D}${systemd_unitdir}/system/
    install -m 0644 ${WORKDIR}/fstrim.timer ${D}${systemd_unitdir}/system/
}

SYSTEMD_PACKAGES = "${PN}-fstrim"
SYSTEMD_SERVICE:${PN}-fstrim = "fstrim.timer"
SYSTEMD_AUTO_ENABLE:${PN}-fstrim = "enable"

FILES:${PN}-fstrim = "\
    ${systemd_unitdir} \
"
