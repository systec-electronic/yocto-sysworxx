do_install:append() {
    # normal users should not be allowed to update the firmware
    chmod o-x "${D}/${bindir}/rauc"
}
