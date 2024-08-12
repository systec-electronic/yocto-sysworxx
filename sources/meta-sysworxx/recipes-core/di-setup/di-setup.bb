SUMMARY = "Setup DI input filter"
LICENSE = "CLOSED"

do_patch[noexec] = "1"
do_configure[noexec] = "1"

RDEPENDS:${PN} = "bash"

inherit systemd

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI = "\
    file://di-setup \
    file://di-setup.sh \
    file://di-setup.service \
"

do_install() {
    install -d ${D}${sysconfdir}/systec
    install -m 0644 ${WORKDIR}/di-setup ${D}${sysconfdir}/systec/di-setup

    install -d ${D}${sbindir}
    install -m 0755 ${WORKDIR}/di-setup.sh ${D}${sbindir}/di-setup.sh

    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/di-setup.service ${D}${systemd_unitdir}/system
}

SYSTEMD_SERVICE:${PN} = "di-setup.service"

FILES:${PN} += "\
    ${sbindir} \
"
