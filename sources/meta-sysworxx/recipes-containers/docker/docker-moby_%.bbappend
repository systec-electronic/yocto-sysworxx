FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
    file://daemon.json \
"

do_install:append() {
    install -m 0644 ${WORKDIR}/daemon.json ${D}${sysconfdir}/docker/daemon.json
}
