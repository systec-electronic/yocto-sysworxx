FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

inherit systemd

SRC_URI:append:sysworxx = "\
    file://etc.mount \
    file://var.mount \
    file://userpart-prepare.service \
"

do_install:append:sysworxx () {
    # create mountpoint for vendor partition
    install -d ${D}/boot/vendor
    install -d ${D}/boot/u-boot

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/etc.mount ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/var.mount ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/userpart-prepare.service ${D}${systemd_system_unitdir}
}

FILES:${PN}:append:sysworxx = "\
    /boot/u-boot \
    /boot/vendor \
"

SYSTEMD_SERVICE:${PN}:append:sysworxx = " \
    userpart-prepare.service \
"
