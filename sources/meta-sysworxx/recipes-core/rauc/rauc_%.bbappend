FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append := " file://system.conf"

RDEPENDS:${PN}="u-boot-ti-staging-env"

do_install:append() {
    # normal users should not be allowed to update the firmware
    chmod o-x "${D}/${bindir}/rauc"
}

do_copy_keyring[dirs] = "${WORKDIR}"
do_copy_keyring() {
    cp "${SYSWORXX_RAUC_CRT_FILE}" "${WORKDIR}/${RAUC_KEYRING_FILE}"
}
do_unpack[postfuncs] += "do_copy_keyring"
