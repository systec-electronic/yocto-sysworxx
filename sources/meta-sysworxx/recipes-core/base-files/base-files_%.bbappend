FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

do_install:append () {
    # create mountpoint for vendor partition
    install -d ${D}/vendor
}

FILES:${PN} += "\
    /vendor \
"
