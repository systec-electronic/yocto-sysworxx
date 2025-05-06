LICENSE = "CC-BY-ND-4.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/CC-BY-ND-4.0;md5=ab85f6aeae6fce4e9ac8d74990974b86"
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

