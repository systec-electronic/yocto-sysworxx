LICENSE = "CLOSED"
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

SRC_URI = " \
    file://systec_logo.html \
    file://systec_logo_2019.svg \
"

do_install () {
    install -d ${D}${datadir}/systec-logo
    install -m 644 ${WORKDIR}/systec_logo.html ${D}${datadir}/systec-logo
    install -m 644 ${WORKDIR}/systec_logo_2019.svg ${D}${datadir}/systec-logo
}

