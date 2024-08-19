SUMMARY = "Setup ADC inputs"
LICENSE = "CLOSED"

do_patch[noexec] = "1"
do_configure[noexec] = "1"

inherit systemd

RDEPENDS:${PN} = "bash"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI = "\
    file://adc-setup \
    file://adc-setup.sh \
    file://adc-setup.service \
"

do_install() {
    install -d ${D}${sysconfdir}/systec
    install -m 0644 ${WORKDIR}/adc-setup ${D}${sysconfdir}/systec/adc-setup

    install -d ${D}${sbindir}
    install -m 0755 ${WORKDIR}/adc-setup.sh ${D}${sbindir}/adc-setup.sh

    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/adc-setup.service ${D}${systemd_unitdir}/system
}

SYSTEMD_SERVICE:${PN} = "adc-setup.service"

FILES:${PN} += "\
    ${sbindir} \
"
