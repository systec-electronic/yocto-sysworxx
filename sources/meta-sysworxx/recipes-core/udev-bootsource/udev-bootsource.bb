do_compile[noexec] = "1"
do_configure[noexec] = "1"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

SRC_URI = " \
    file://50-bootsource.rules \
    file://is_bootsource.sh \
"

S="${WORKDIR}"

do_install() {
    install -m 0755 -d ${D}${base_sbindir}
    install -m 0700 ${S}/is_bootsource.sh ${D}${base_sbindir}/is_bootsource

    install -m 0755 -d ${D}${sysconfdir}/udev/rules.d/
    install -m 0644 ${S}/50-bootsource.rules ${D}${sysconfdir}/udev/rules.d/
}
