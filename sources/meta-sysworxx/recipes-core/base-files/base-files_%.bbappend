FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

inherit systemd

SRC_URI += "\
    file://etc.mount \
    file://var.mount \
    file://userpart-prepare.service \
"

do_install:append () {
    # create mountpoint for vendor partition
    install -d ${D}/vendor

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/etc.mount ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/var.mount ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/userpart-prepare.service ${D}${systemd_system_unitdir}
}

FILES:${PN} += "\
    /vendor \
"

SYSTEMD_SERVICE:${PN} = " \
    userpart-prepare.service \
"
